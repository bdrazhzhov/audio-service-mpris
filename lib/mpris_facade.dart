part of 'audio_service_mpris.dart';

/// This class exposes properties from the MPRIS specification:
/// - [org.mpris.MediaPlayer2](https://specifications.freedesktop.org/mpris/latest/Media_Player.html)
/// - [org.mpris.MediaPlayer2.Player](https://specifications.freedesktop.org/mpris/latest/Player_Interface.html)
class Mpris {
  final _MprisMediaPlayer _mpris = _MprisMediaPlayer();

  Mpris._();
  static final Mpris _instance = Mpris._();

  factory Mpris() {
    return _instance;
  }

  // ==================== org.mpris.MediaPlayer2 Properties ====================

  /// If false, calling Quit will have no effect and may raise a NotSupported error.
  /// If true, calling Quit will cause the media application to attempt to quit.
  bool get canQuit => _mpris.canQuit;
  set canQuit(bool value) => _mpris.canQuit = value;

  /// Whether the media player is occupying the fullscreen.
  /// A value of `true` indicates that the media player is taking up the full screen.
  ///
  /// If [canSetFullscreen] is true, clients may set this property to `true` to tell
  /// the media player to enter fullscreen mode, or to `false` to return to windowed mode.
  bool get fullscreen => _mpris.fullscreen;
  set fullscreen(bool value) => _mpris.fullscreen = value;

  /// If false, attempting to set [fullscreen] will have no effect and may raise an error.
  /// If true, attempting to set [fullscreen] will cause the media player to attempt
  /// to enter or exit fullscreen mode.
  bool get canSetFullscreen => _mpris.canSetFullscreen;
  set canSetFullscreen(bool value) => _mpris.canSetFullscreen = value;

  /// If false, calling Raise will have no effect and may raise a NotSupported error.
  /// If true, calling Raise will cause the media application to attempt to bring
  /// its user interface to the front.
  bool get canRaise => _mpris.canRaise;
  set canRaise(bool value) => _mpris.canRaise = value;

  /// Indicates whether the `/org/mpris/MediaPlayer2` object implements
  /// the `org.mpris.MediaPlayer2.TrackList` interface.
  bool get hasTrackList => _mpris.hasTrackList;
  set hasTrackList(bool value) => _mpris.hasTrackList = value;

  /// A friendly name to identify the media player to users.
  /// This should usually match the name found in .desktop files (e.g.: "VLC media player").
  String get identity => _mpris.identity;
  set identity(String value) => _mpris.identity = value;

  /// The basename of an installed .desktop file which complies with the Desktop entry
  /// specification, with the ".desktop" extension stripped.
  ///
  /// Example: The desktop entry file is "/usr/share/applications/vlc.desktop",
  /// and this property contains "vlc".
  String get desktopEntry => _mpris.desktopEntry;
  set desktopEntry(String value) => _mpris.desktopEntry = value;

  /// The URI schemes supported by the media player.
  /// This can be viewed as protocols supported by the player in almost all cases.
  /// Almost every media player will include support for the "file" scheme.
  /// Other common schemes are "http" and "rtsp".
  ///
  /// Note that URI schemes should be lower-case.
  List<String> get supportedUriSchemes => _mpris.supportedUriSchemes;
  set supportedUriSchemes(List<String> value) => _mpris.supportedUriSchemes = value;

  /// The mime-types supported by the media player.
  /// Mime-types should be in the standard format (e.g.: audio/mpeg or application/ogg).
  List<String> get supportedMimeTypes => _mpris.supportedMimeTypes;
  set supportedMimeTypes(List<String> value) => _mpris.supportedMimeTypes = value;

  // ==================== org.mpris.MediaPlayer2.Player Properties ====================

  /// The minimum value which the [rate] property can take.
  ///
  /// Clients should not attempt to set the [rate] property below this value.
  /// Note that even if this value is 0.0 or negative, clients should not attempt
  /// to set the [rate] property to 0.0.
  ///
  /// This value should always be 1.0 or less.
  double get minimumRate => _mpris.minimumRate;
  set minimumRate(double value) => _mpris.minimumRate = value;

  /// The maximum value which the [rate] property can take.
  ///
  /// Clients should not attempt to set the [rate] property above this value.
  ///
  /// This value should always be 1.0 or greater.
  double get maximumRate => _mpris.maximumRate;
  set maximumRate(double value) => _mpris.maximumRate = value;

  /// Whether the client can call the Next method on this interface and expect
  /// the current track to change.
  ///
  /// If it is unknown whether a call to Next will be successful (for example,
  /// when streaming tracks), this property should be set to true.
  ///
  /// If [canControl] is false, this property should also be false.
  bool get canGoNext => _mpris.canGoNext;
  set canGoNext(bool value) => _mpris.canGoNext = _mpris.canControl && value;

  /// Whether the client can call the Previous method on this interface and expect
  /// the current track to change.
  ///
  /// If it is unknown whether a call to Previous will be successful (for example,
  /// when streaming tracks), this property should be set to true.
  ///
  /// If [canControl] is false, this property should also be false.
  bool get canGoPrevious => _mpris.canGoPrevious;
  set canGoPrevious(bool value) => _mpris.canGoPrevious = _mpris.canControl && value;

  /// Whether playback can be started using Play or PlayPause.
  ///
  /// Note that this is related to whether there is a "current track": the value
  /// should not depend on whether the track is currently paused or playing.
  /// In fact, if a track is currently playing (and [canControl] is true),
  /// this should be true.
  ///
  /// If [canControl] is false, this property should also be false.
  bool get canPlay => _mpris.canPlay;
  set canPlay(bool value) => _mpris.canPlay = _mpris.canControl && value;

  /// Whether playback can be paused using Pause or PlayPause.
  ///
  /// Note that this is an intrinsic property of the current track: its value
  /// should not depend on whether the track is currently paused or playing.
  /// In fact, if playback is currently paused (and [canControl] is true),
  /// this should be true.
  ///
  /// If [canControl] is false, this property should also be false.
  bool get canPause => _mpris.canPause;
  set canPause(bool value) => _mpris.canPause = _mpris.canControl && value;

  /// Whether the media player may be controlled over this interface.
  ///
  /// This property is not expected to change, as it describes an intrinsic
  /// capability of the implementation.
  ///
  /// If this is false, clients should assume that all properties on this interface
  /// are read-only (and will raise errors if writing to them is attempted),
  /// no methods are implemented and all other properties starting with "Can"
  /// are also false.
  bool get canControl => _mpris.canControl;
  set canControl(bool value) => _mpris.canControl = value;
}
