// This file was generated using the following command and may be overwritten.
// dart-dbus generate-object dbus-interfaces/org.mpris.xml

import 'dart:async';

import 'package:dbus/dbus.dart';
import 'package:flutter/foundation.dart';

import 'metadata.dart';

class OrgMprisMediaPlayer2 extends DBusObject {
  final String identity;
  final _stateStreamController = StreamController<String>();
  Stream<String> get controlStream => _stateStreamController.stream;

  final _positionStreamController = StreamController<Duration>();
  Stream<Duration> get positionStream => _positionStreamController.stream;

  final _openUriStreamController = StreamController<Uri>();
  Stream<Uri> get openUriStream => _openUriStreamController.stream;

  final _volumeStreamController = StreamController<double>();
  Stream<double> get volumeStream => _volumeStreamController.stream;

  var position = const Duration(seconds: 0);

  /// Creates a new object to expose on [path].
  OrgMprisMediaPlayer2(
      {DBusObjectPath path = const DBusObjectPath.unchecked('/'),
      required this.identity})
      : super(path);

  /// Gets value of property org.mpris.MediaPlayer2.CanQuit
  Future<DBusMethodResponse> getCanQuit() async {
    return DBusMethodSuccessResponse([const DBusBoolean(false)]);
  }

  /// Gets value of property org.mpris.MediaPlayer2.Fullscreen
  Future<DBusMethodResponse> getFullscreen() async {
    return DBusMethodSuccessResponse([const DBusBoolean(false)]);
  }

  /// Sets property org.mpris.MediaPlayer2.Fullscreen
  Future<DBusMethodResponse> setFullscreen(bool value) async {
    return DBusMethodSuccessResponse([const DBusBoolean(false)]);
  }

  /// Gets value of property org.mpris.MediaPlayer2.CanSetFullscreen
  Future<DBusMethodResponse> getCanSetFullscreen() async {
    return DBusMethodSuccessResponse([const DBusBoolean(false)]);
  }

  /// Gets value of property org.mpris.MediaPlayer2.CanRaise
  Future<DBusMethodResponse> getCanRaise() async {
    return DBusMethodSuccessResponse([const DBusBoolean(false)]);
  }

  /// Gets value of property org.mpris.MediaPlayer2.HasTrackList
  Future<DBusMethodResponse> getHasTrackList() async {
    return DBusMethodSuccessResponse([const DBusBoolean(false)]);
  }

  /// Gets value of property org.mpris.MediaPlayer2.Identity
  Future<DBusMethodResponse> getIdentity() async {
    return DBusMethodSuccessResponse([DBusString(identity)]);
  }

  /// Gets value of property org.mpris.MediaPlayer2.DesktopEntry
  Future<DBusMethodResponse> getDesktopEntry() async {
    return DBusMethodSuccessResponse([const DBusString('')]);
  }

  /// Gets value of property org.mpris.MediaPlayer2.SupportedUriSchemes
  Future<DBusMethodResponse> getSupportedUriSchemes() async {
    return DBusMethodSuccessResponse([DBusArray.string([])]);
  }

  /// Gets value of property org.mpris.MediaPlayer2.SupportedMimeTypes
  Future<DBusMethodResponse> getSupportedMimeTypes() async {
    return DBusMethodSuccessResponse([DBusArray.string([])]);
  }

  /// Implementation of org.mpris.MediaPlayer2.Raise()
  Future<DBusMethodResponse> doRaise() async {
    return DBusMethodSuccessResponse([]);
  }

  /// Implementation of org.mpris.MediaPlayer2.Quit()
  Future<DBusMethodResponse> doQuit() async {
    return DBusMethodSuccessResponse([]);
  }

  String _playbackState = 'Stopped';
  String get playbackState => _playbackState;

  set playbackState(String state) {
    if (state == _playbackState) return;

    emitPropertiesChanged(
      "org.mpris.MediaPlayer2.Player",
      changedProperties: {"PlaybackStatus": DBusString(state)},
    );
    _playbackState = state;
  }

  /// Gets value of property org.mpris.MediaPlayer2.Player.PlaybackStatus
  Future<DBusMethodResponse> _getPlaybackStatus() async {
    return DBusMethodSuccessResponse([DBusString(_playbackState)]);
  }

  /// Gets value of property org.mpris.MediaPlayer2.Player.LoopStatus
  Future<DBusMethodResponse> getLoopStatus() async {
    return DBusMethodSuccessResponse([const DBusString('None')]);
  }

  /// Sets property org.mpris.MediaPlayer2.Player.LoopStatus
  Future<DBusMethodResponse> setLoopStatus(String value) async {
    debugPrint('Set org.mpris.MediaPlayer2.Player.LoopStatus not implemented');
    return DBusMethodSuccessResponse([]);
  }

  /// Gets value of property org.mpris.MediaPlayer2.Player.Rate
  Future<DBusMethodResponse> getRate() async {
    return DBusMethodSuccessResponse([const DBusDouble(1.0)]);
  }

  /// Sets property org.mpris.MediaPlayer2.Player.Rate
  Future<DBusMethodResponse> setRate(double value) async {
    debugPrint('Set org.mpris.MediaPlayer2.Player.Rate not implemented');
    return DBusMethodSuccessResponse([]);
  }

  Metadata _metadata = Metadata(
    trackId: "/org/mpris/MediaPlayer2/TrackList/NoTrack",
    title: "No title",
  );
  Metadata get metadata => _metadata;
  set metadata(Metadata metadata) {
    if (metadata == _metadata) return;
    emitPropertiesChanged(
      "org.mpris.MediaPlayer2.Player",
      changedProperties: {"Metadata": metadata.toValue()},
    );
    _metadata = metadata;
  }

  /// Gets value of property org.mpris.MediaPlayer2.Player.Metadata
  Future<DBusMethodResponse> getMetadata() async {
    return DBusMethodSuccessResponse([_metadata.toValue()]);
  }

  /// Gets value of property org.mpris.MediaPlayer2.Player.Volume
  Future<DBusMethodResponse> getVolume() async {
    debugPrint('Get org.mpris.MediaPlayer2.Player.Volume not implemented');
    return DBusMethodSuccessResponse([const DBusDouble(1.0)]);
  }

  /// Sets property org.mpris.MediaPlayer2.Player.Volume
  Future<DBusMethodResponse> setVolume(double value) async {
    _volumeStreamController.add(value);
    return DBusMethodSuccessResponse([]);
  }

  /// Gets value of property org.mpris.MediaPlayer2.Player.Position
  Future<DBusMethodResponse> getPosition() async {
    debugPrint('GetPosition(): $position');
    return DBusMethodSuccessResponse(
        [DBusVariant(DBusInt64(position.inMicroseconds))]);
  }

  /// Gets value of property org.mpris.MediaPlayer2.Player.MinimumRate
  Future<DBusMethodResponse> getMinimumRate() async {
    return DBusMethodSuccessResponse([const DBusDouble(1.0)]);
  }

  /// Gets value of property org.mpris.MediaPlayer2.Player.MaximumRate
  Future<DBusMethodResponse> getMaximumRate() async {
    return DBusMethodSuccessResponse([const DBusDouble(1.0)]);
  }

  /// Gets value of property org.mpris.MediaPlayer2.Player.CanGoNext
  Future<DBusMethodResponse> getCanGoNext() async {
    return DBusMethodSuccessResponse([const DBusBoolean(true)]);
  }

  /// Gets value of property org.mpris.MediaPlayer2.Player.CanGoPrevious
  Future<DBusMethodResponse> getCanGoPrevious() async {
    return DBusMethodSuccessResponse([const DBusBoolean(true)]);
  }

  /// Gets value of property org.mpris.MediaPlayer2.Player.CanPlay
  Future<DBusMethodResponse> getCanPlay() async {
    return DBusMethodSuccessResponse([const DBusBoolean(true)]);
  }

  /// Gets value of property org.mpris.MediaPlayer2.Player.CanPause
  Future<DBusMethodResponse> getCanPause() async {
    return DBusMethodSuccessResponse([const DBusBoolean(true)]);
  }

  /// Gets value of property org.mpris.MediaPlayer2.Player.CanSeek
  Future<DBusMethodResponse> getCanSeek() async {
    return DBusMethodSuccessResponse([const DBusBoolean(true)]);
  }

  /// Gets value of property org.mpris.MediaPlayer2.Player.CanControl
  Future<DBusMethodResponse> getCanControl() async {
    return DBusMethodSuccessResponse([const DBusBoolean(true)]);
  }

  /// Implementation of org.mpris.MediaPlayer2.Player.Next()
  Future<DBusMethodResponse> doNext() async {
    _stateStreamController.add('next');
    return DBusMethodSuccessResponse([]);
  }

  /// Implementation of org.mpris.MediaPlayer2.Player.Previous()
  Future<DBusMethodResponse> doPrevious() async {
    _stateStreamController.add('previous');
    return DBusMethodSuccessResponse([]);
  }

  /// Implementation of org.mpris.MediaPlayer2.Player.Pause()
  Future<DBusMethodResponse> doPause() async {
    _stateStreamController.add('pause');
    return DBusMethodSuccessResponse([]);
  }

  /// Implementation of org.mpris.MediaPlayer2.Player.PlayPause()
  Future<DBusMethodResponse> doPlayPause() async {
    _stateStreamController.add('playPause');
    return DBusMethodSuccessResponse([]);
  }

  /// Implementation of org.mpris.MediaPlayer2.Player.Stop()
  Future<DBusMethodResponse> doStop() async {
    _stateStreamController.add('stop');
    return DBusMethodSuccessResponse([]);
  }

  /// Implementation of org.mpris.MediaPlayer2.Player.Play()
  Future<DBusMethodResponse> doPlay() async {
    _stateStreamController.add('play');
    return DBusMethodSuccessResponse([]);
  }

  /// Implementation of org.mpris.MediaPlayer2.Player.Seek()
  Future<DBusMethodResponse> doSeek(int offset) async {
    debugPrint('org.mpris.MediaPlayer2.Player.Seek() not implemented');
    return DBusMethodSuccessResponse([]);
  }

  /// Implementation of org.mpris.MediaPlayer2.Player.SetPosition()
  Future<DBusMethodResponse> doSetPosition(String trackId, int position) async {
    _positionStreamController.add(Duration(microseconds: position));
    return DBusMethodSuccessResponse([]);
  }

  /// Implementation of org.mpris.MediaPlayer2.Player.OpenUri()
  Future<DBusMethodResponse> doOpenUri(String uri) async {
    _openUriStreamController.add(Uri.parse(uri));
    return DBusMethodSuccessResponse([]);
  }

  /// Emits signal org.mpris.MediaPlayer2.Player.Seeked
  Future<void> emitSeeked(Duration position) async {
    await emitSignal('org.mpris.MediaPlayer2.Player', 'Seeked',
        [DBusInt64(position.inMicroseconds)]);
  }

  @override
  List<DBusIntrospectInterface> introspect() {
    return [
      DBusIntrospectInterface('org.mpris.MediaPlayer2', methods: [
        DBusIntrospectMethod('Raise'),
        DBusIntrospectMethod('Quit')
      ], properties: [
        DBusIntrospectProperty('CanQuit', DBusSignature('b'),
            access: DBusPropertyAccess.read),
        //DBusIntrospectProperty('Fullscreen', DBusSignature('b'),
        //    access: DBusPropertyAccess.readwrite),
        //DBusIntrospectProperty('CanSetFullscreen', DBusSignature('b'),
        //    access: DBusPropertyAccess.read),
        DBusIntrospectProperty('CanRaise', DBusSignature('b'),
            access: DBusPropertyAccess.read),
        DBusIntrospectProperty('HasTrackList', DBusSignature('b'),
            access: DBusPropertyAccess.read),
        DBusIntrospectProperty('Identity', DBusSignature('s'),
            access: DBusPropertyAccess.read),
        //DBusIntrospectProperty('DesktopEntry', DBusSignature('s'),
        //    access: DBusPropertyAccess.read),
        DBusIntrospectProperty('SupportedUriSchemes', DBusSignature('as'),
            access: DBusPropertyAccess.read),
        DBusIntrospectProperty('SupportedMimeTypes', DBusSignature('as'),
            access: DBusPropertyAccess.read)
      ]),
      DBusIntrospectInterface('org.mpris.MediaPlayer2.Player', methods: [
        DBusIntrospectMethod('Next'),
        DBusIntrospectMethod('Previous'),
        DBusIntrospectMethod('Pause'),
        DBusIntrospectMethod('PlayPause'),
        DBusIntrospectMethod('Stop'),
        DBusIntrospectMethod('Play'),
        DBusIntrospectMethod('Seek', args: [
          DBusIntrospectArgument(DBusSignature('x'), DBusArgumentDirection.in_,
              name: 'Offset')
        ]),
        DBusIntrospectMethod('SetPosition', args: [
          DBusIntrospectArgument(DBusSignature('o'), DBusArgumentDirection.in_,
              name: 'TrackId'),
          DBusIntrospectArgument(DBusSignature('x'), DBusArgumentDirection.in_,
              name: 'Position')
        ]),
        DBusIntrospectMethod('OpenUri', args: [
          DBusIntrospectArgument(DBusSignature('s'), DBusArgumentDirection.in_,
              name: 'Uri')
        ])
      ], signals: [
        DBusIntrospectSignal('Seeked', args: [
          DBusIntrospectArgument(DBusSignature('x'), DBusArgumentDirection.out,
              name: 'Position')
        ])
      ], properties: [
        DBusIntrospectProperty('PlaybackStatus', DBusSignature('s'),
            access: DBusPropertyAccess.read),
        DBusIntrospectProperty('LoopStatus', DBusSignature('s'),
            access: DBusPropertyAccess.readwrite),
        DBusIntrospectProperty('Rate', DBusSignature('d'),
            access: DBusPropertyAccess.readwrite),
        DBusIntrospectProperty('Metadata', DBusSignature('a{sv}'),
            access: DBusPropertyAccess.read),
        DBusIntrospectProperty('Volume', DBusSignature('d'),
            access: DBusPropertyAccess.readwrite),
        DBusIntrospectProperty('Position', DBusSignature('x'),
            access: DBusPropertyAccess.read),
        DBusIntrospectProperty('MinimumRate', DBusSignature('d'),
            access: DBusPropertyAccess.read),
        DBusIntrospectProperty('MaximumRate', DBusSignature('d'),
            access: DBusPropertyAccess.read),
        DBusIntrospectProperty('CanGoNext', DBusSignature('b'),
            access: DBusPropertyAccess.read),
        DBusIntrospectProperty('CanGoPrevious', DBusSignature('b'),
            access: DBusPropertyAccess.read),
        DBusIntrospectProperty('CanPlay', DBusSignature('b'),
            access: DBusPropertyAccess.read),
        DBusIntrospectProperty('CanPause', DBusSignature('b'),
            access: DBusPropertyAccess.read),
        DBusIntrospectProperty('CanSeek', DBusSignature('b'),
            access: DBusPropertyAccess.read),
        DBusIntrospectProperty('CanControl', DBusSignature('b'),
            access: DBusPropertyAccess.read)
      ])
    ];
  }

  @override
  Future<DBusMethodResponse> handleMethodCall(DBusMethodCall methodCall) async {
    if (methodCall.interface == 'org.mpris.MediaPlayer2') {
      if (methodCall.name == 'Raise') {
        if (methodCall.values.isNotEmpty) {
          return DBusMethodErrorResponse.invalidArgs();
        }
        return doRaise();
      } else if (methodCall.name == 'Quit') {
        if (methodCall.values.isNotEmpty) {
          return DBusMethodErrorResponse.invalidArgs();
        }
        return doQuit();
      } else {
        return DBusMethodErrorResponse.unknownMethod();
      }
    } else if (methodCall.interface == 'org.mpris.MediaPlayer2.Player') {
      if (methodCall.name == 'Next') {
        if (methodCall.values.isNotEmpty) {
          return DBusMethodErrorResponse.invalidArgs();
        }
        return doNext();
      } else if (methodCall.name == 'Previous') {
        if (methodCall.values.isNotEmpty) {
          return DBusMethodErrorResponse.invalidArgs();
        }
        return doPrevious();
      } else if (methodCall.name == 'Pause') {
        if (methodCall.values.isNotEmpty) {
          return DBusMethodErrorResponse.invalidArgs();
        }
        return doPause();
      } else if (methodCall.name == 'PlayPause') {
        if (methodCall.values.isNotEmpty) {
          return DBusMethodErrorResponse.invalidArgs();
        }
        return doPlayPause();
      } else if (methodCall.name == 'Stop') {
        if (methodCall.values.isNotEmpty) {
          return DBusMethodErrorResponse.invalidArgs();
        }
        return doStop();
      } else if (methodCall.name == 'Play') {
        if (methodCall.values.isNotEmpty) {
          return DBusMethodErrorResponse.invalidArgs();
        }
        return doPlay();
      } else if (methodCall.name == 'Seek') {
        if (methodCall.signature != DBusSignature('x')) {
          return DBusMethodErrorResponse.invalidArgs();
        }
        return doSeek(methodCall.values[0].asInt64());
      } else if (methodCall.name == 'SetPosition') {
        if (methodCall.signature != DBusSignature('ox')) {
          return DBusMethodErrorResponse.invalidArgs();
        }
        return doSetPosition(methodCall.values[0].asObjectPath().toString(),
            methodCall.values[1].asInt64());
      } else if (methodCall.name == 'OpenUri') {
        if (methodCall.signature != DBusSignature('s')) {
          return DBusMethodErrorResponse.invalidArgs();
        }
        return doOpenUri(methodCall.values[0].asString());
      } else {
        return DBusMethodErrorResponse.unknownMethod();
      }
    } else {
      return DBusMethodErrorResponse.unknownInterface();
    }
  }

  @override
  Future<DBusMethodResponse> getProperty(String interface, String name) async {
    debugPrint('Requested property $name from $interface');

    if (interface == 'org.mpris.MediaPlayer2') {
      if (name == 'CanQuit') {
        return getCanQuit();
      } else if (name == 'Fullscreen') {
        return getFullscreen();
      } else if (name == 'CanSetFullscreen') {
        return getCanSetFullscreen();
      } else if (name == 'CanRaise') {
        return getCanRaise();
      } else if (name == 'HasTrackList') {
        return getHasTrackList();
      } else if (name == 'Identity') {
        return getIdentity();
      } else if (name == 'DesktopEntry') {
        return getDesktopEntry();
      } else if (name == 'SupportedUriSchemes') {
        return getSupportedUriSchemes();
      } else if (name == 'SupportedMimeTypes') {
        return getSupportedMimeTypes();
      } else {
        return DBusMethodErrorResponse.unknownProperty();
      }
    } else if (interface == 'org.mpris.MediaPlayer2.Player') {
      if (name == 'PlaybackStatus') {
        return _getPlaybackStatus();
      } else if (name == 'LoopStatus') {
        return getLoopStatus();
      } else if (name == 'Rate') {
        return getRate();
      } else if (name == 'Metadata') {
        return getMetadata();
      } else if (name == 'Volume') {
        return getVolume();
      } else if (name == 'Position') {
        return getPosition();
      } else if (name == 'MinimumRate') {
        return getMinimumRate();
      } else if (name == 'MaximumRate') {
        return getMaximumRate();
      } else if (name == 'CanGoNext') {
        return getCanGoNext();
      } else if (name == 'CanGoPrevious') {
        return getCanGoPrevious();
      } else if (name == 'CanPlay') {
        return getCanPlay();
      } else if (name == 'CanPause') {
        return getCanPause();
      } else if (name == 'CanSeek') {
        return getCanSeek();
      } else if (name == 'CanControl') {
        return getCanControl();
      } else {
        return DBusMethodErrorResponse.unknownProperty();
      }
    } else {
      return DBusMethodErrorResponse.unknownProperty();
    }
  }

  @override
  Future<DBusMethodResponse> setProperty(
      String interface, String name, DBusValue value) async {
    if (interface == 'org.mpris.MediaPlayer2') {
      if (name == 'CanQuit') {
        return DBusMethodErrorResponse.propertyReadOnly();
      } else if (name == 'Fullscreen') {
        if (value.signature != DBusSignature('b')) {
          return DBusMethodErrorResponse.invalidArgs();
        }
        return setFullscreen(value.asBoolean());
      } else if (name == 'CanSetFullscreen') {
        return DBusMethodErrorResponse.propertyReadOnly();
      } else if (name == 'CanRaise') {
        return DBusMethodErrorResponse.propertyReadOnly();
      } else if (name == 'HasTrackList') {
        return DBusMethodErrorResponse.propertyReadOnly();
      } else if (name == 'Identity') {
        return DBusMethodErrorResponse.propertyReadOnly();
      } else if (name == 'DesktopEntry') {
        return DBusMethodErrorResponse.propertyReadOnly();
      } else if (name == 'SupportedUriSchemes') {
        return DBusMethodErrorResponse.propertyReadOnly();
      } else if (name == 'SupportedMimeTypes') {
        return DBusMethodErrorResponse.propertyReadOnly();
      } else {
        return DBusMethodErrorResponse.unknownProperty();
      }
    } else if (interface == 'org.mpris.MediaPlayer2.Player') {
      if (name == 'PlaybackStatus') {
        return DBusMethodErrorResponse.propertyReadOnly();
      } else if (name == 'LoopStatus') {
        if (value.signature != DBusSignature('s')) {
          return DBusMethodErrorResponse.invalidArgs();
        }
        return setLoopStatus(value.asString());
      } else if (name == 'Rate') {
        if (value.signature != DBusSignature('d')) {
          return DBusMethodErrorResponse.invalidArgs();
        }
        return setRate(value.asDouble());
      } else if (name == 'Metadata') {
        return DBusMethodErrorResponse.propertyReadOnly();
      } else if (name == 'Volume') {
        if (value.signature != DBusSignature('d')) {
          return DBusMethodErrorResponse.invalidArgs();
        }
        return setVolume(value.asDouble());
      } else if (name == 'Position') {
        return DBusMethodErrorResponse.propertyReadOnly();
      } else if (name == 'MinimumRate') {
        return DBusMethodErrorResponse.propertyReadOnly();
      } else if (name == 'MaximumRate') {
        return DBusMethodErrorResponse.propertyReadOnly();
      } else if (name == 'CanGoNext') {
        return DBusMethodErrorResponse.propertyReadOnly();
      } else if (name == 'CanGoPrevious') {
        return DBusMethodErrorResponse.propertyReadOnly();
      } else if (name == 'CanPlay') {
        return DBusMethodErrorResponse.propertyReadOnly();
      } else if (name == 'CanPause') {
        return DBusMethodErrorResponse.propertyReadOnly();
      } else if (name == 'CanSeek') {
        return DBusMethodErrorResponse.propertyReadOnly();
      } else if (name == 'CanControl') {
        return DBusMethodErrorResponse.propertyReadOnly();
      } else {
        return DBusMethodErrorResponse.unknownProperty();
      }
    } else {
      return DBusMethodErrorResponse.unknownProperty();
    }
  }

  @override
  Future<DBusMethodResponse> getAllProperties(String interface) async {
    var properties = <String, DBusValue>{};
    if (interface == 'org.mpris.MediaPlayer2') {
      properties['CanQuit'] = (await getCanQuit()).returnValues[0];
      // properties['Fullscreen'] = (await getFullscreen()).returnValues[0];
      // properties['CanSetFullscreen'] =
      //     (await getCanSetFullscreen()).returnValues[0];
      properties['CanRaise'] = (await getCanRaise()).returnValues[0];
      properties['HasTrackList'] = (await getHasTrackList()).returnValues[0];
      properties['Identity'] = (await getIdentity()).returnValues[0];
      // properties['DesktopEntry'] = (await getDesktopEntry()).returnValues[0];
      properties['SupportedUriSchemes'] =
          (await getSupportedUriSchemes()).returnValues[0];
      properties['SupportedMimeTypes'] =
          (await getSupportedMimeTypes()).returnValues[0];
    } else if (interface == 'org.mpris.MediaPlayer2.Player') {
      properties['PlaybackStatus'] =
          (await _getPlaybackStatus()).returnValues[0];
      properties['LoopStatus'] = (await getLoopStatus()).returnValues[0];
      properties['Rate'] = (await getRate()).returnValues[0];
      properties['Metadata'] = (await getMetadata()).returnValues[0];
      properties['Volume'] = (await getVolume()).returnValues[0];
      properties['Position'] = (await getPosition()).returnValues[0];
      properties['MinimumRate'] = (await getMinimumRate()).returnValues[0];
      properties['MaximumRate'] = (await getMaximumRate()).returnValues[0];
      properties['CanGoNext'] = (await getCanGoNext()).returnValues[0];
      properties['CanGoPrevious'] = (await getCanGoPrevious()).returnValues[0];
      properties['CanPlay'] = (await getCanPlay()).returnValues[0];
      properties['CanPause'] = (await getCanPause()).returnValues[0];
      properties['CanSeek'] = (await getCanSeek()).returnValues[0];
      properties['CanControl'] = (await getCanControl()).returnValues[0];
    }
    return DBusMethodSuccessResponse([DBusDict.stringVariant(properties)]);
  }
}
