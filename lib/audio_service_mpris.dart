import 'dart:io';

import 'package:audio_service_platform_interface/audio_service_platform_interface.dart';
import 'package:dbus/dbus.dart';
import 'package:flutter/foundation.dart';

import 'mpris.dart';
import 'metadata.dart';

class AudioServiceMpris extends AudioServicePlatform {
  late final DBusClient _dBusClient;
  late final OrgMprisMediaPlayer2 _mpris;
  AudioHandlerCallbacks? _handlerCallbacks;
  bool _isPlaying = false;

  void _listenToOpenUriStream() {
    _mpris.openUriStream.listen((uri) {
      if (_handlerCallbacks == null) return;

      _handlerCallbacks!.playFromUri(PlayFromUriRequest(uri: uri));
    });
  }

  void _listenToSeekStream() {
    _mpris.positionStream.listen((position) {
      if (_handlerCallbacks == null) return;

      _handlerCallbacks!.seek(SeekRequest(position: position));
    });
  }

  void _listenToControlStream() {
    _mpris.controlStream.listen((event) {
      debugPrint('Requested from DBus: $event');
      if (_handlerCallbacks == null) return;

      switch (event) {
        case 'play':
          _handlerCallbacks!.play(const PlayRequest());
        case 'pause':
          _handlerCallbacks!.pause(const PauseRequest());
        case 'next':
          _handlerCallbacks!.skipToNext(const SkipToNextRequest());
        case 'previous':
          _handlerCallbacks!.skipToPrevious(const SkipToPreviousRequest());
        case 'playPause':
          _isPlaying
              ? _handlerCallbacks!.pause(const PauseRequest())
              : _handlerCallbacks!.play(const PlayRequest());
      }
    });
  }

  void _listenToVolumeStream() {
    _mpris.volumeStream.listen((value) {
      if (_handlerCallbacks == null) return;

      _handlerCallbacks!.customAction(
          CustomActionRequest(name: 'dbusVolume', extras: {'value': value}));
    });
  }

  static void registerWith() {
    AudioServicePlatform.instance = AudioServiceMpris();
  }

  @override
  Future<void> configure(ConfigureRequest request) async {
    debugPrint('Configure AudioServiceLinux.');

    _dBusClient = DBusClient.session();
    _mpris = OrgMprisMediaPlayer2(
        path: DBusObjectPath('/org/mpris/MediaPlayer2'),
        identity: request.config.androidNotificationChannelName);

    _listenToControlStream();
    _listenToSeekStream();
    _listenToOpenUriStream();
    _listenToVolumeStream();

    await _dBusClient.registerObject(_mpris);
    await _dBusClient.requestName(
        'org.mpris.MediaPlayer2.${request.config.androidNotificationChannelId}.instance$pid',
        flags: {DBusRequestNameFlag.doNotQueue});
  }

  @override
  Future<void> setState(SetStateRequest request) async {
    _mpris.position = request.state.updatePosition;
    _isPlaying = request.state.playing;
    _mpris.playbackState = _isPlaying ? 'Playing' : 'Paused';
  }

  @override
  Future<void> setQueue(SetQueueRequest request) async {
    debugPrint('setQueue() has not been implemented.');
  }

  @override
  Future<void> setMediaItem(SetMediaItemRequest request) async {
    List<String>? artist;
    if (request.mediaItem.artist != null) artist = [request.mediaItem.artist!];

    List<String>? genre;
    if (request.mediaItem.genre != null) genre = [request.mediaItem.genre!];

    _mpris.metadata = Metadata(
        trackId: '/trackId/${request.mediaItem.id}',
        title: request.mediaItem.title,
        length: request.mediaItem.duration,
        artist: artist,
        artUrl: request.mediaItem.artUri.toString(),
        album: request.mediaItem.album,
        genre: genre);
  }

  @override
  Future<void> stopService(StopServiceRequest request) async {
    _mpris.playbackState = 'Stopped';
  }

  @override
  Future<void> notifyChildrenChanged(
      NotifyChildrenChangedRequest request) async {
    throw UnimplementedError(
        'notifyChildrenChanged() has not been implemented.');
  }

  @override
  void setHandlerCallbacks(AudioHandlerCallbacks callbacks) {
    _handlerCallbacks = callbacks;
  }
}
