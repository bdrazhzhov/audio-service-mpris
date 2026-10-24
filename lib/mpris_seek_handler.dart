part of 'audio_service_mpris.dart';

class _MprisSeekHandler {
  // Allow for position sampling and timestamp precision, not normal playback.
  static const _positionTolerance = Duration(milliseconds: 100);

  PlaybackStateMessage? _previousState;
  final _MprisMediaPlayer _mpris;

  _MprisSeekHandler({required _MprisMediaPlayer mpris}) : _mpris = mpris;

  void resetPlaybackState() => _previousState = null;

  Future<void> setPlaybackState(PlaybackStateMessage playbackState) async {
    final sought = _hasPositionDiscontinuity(playbackState);
    _previousState =
    playbackState.processingState == AudioProcessingStateMessage.idle ? null : playbackState;
    if (sought) {
      await _mpris.emitSeeked(_currentPosition(playbackState));
    }
  }

  bool _hasPositionDiscontinuity(PlaybackStateMessage state) {
    // audio_service follows the transition to idle with stopService().
    if (state.processingState == AudioProcessingStateMessage.idle) return false;

    final PlaybackStateMessage? previous = _previousState;
    var expected = Duration.zero;
    if (previous != null) {
      final elapsed = state.updateTime.difference(previous.updateTime);
      // A clock adjustment cannot establish a position discontinuity.
      if (elapsed.isNegative) return false;

      expected = previous.updatePosition;
      if (previous.playing) {
        // Use the old rate over this interval, including when pausing or
        // changing speed. Buffering still advertises Playing to MPRIS clients.
        expected += elapsed * previous.speed;
      }
    }

    // A new track or a restart after stop is expected to begin at zero.
    return (state.updatePosition - _clampPosition(expected)).abs() > _positionTolerance;
  }

  Duration _currentPosition(PlaybackStateMessage state) {
    Duration position = state.updatePosition;
    final Duration elapsed = DateTime.now().difference(state.updateTime);
    if (state.playing &&
        state.processingState == AudioProcessingStateMessage.ready &&
        !elapsed.isNegative) {
      position += elapsed * state.speed;
    }
    return _clampPosition(position);
  }

  Duration _clampPosition(Duration position) {
    if (position.isNegative) return Duration.zero;
    final length = _mpris.metadata.length;
    if (length != null && position > length) return length;
    return position;
  }
}
