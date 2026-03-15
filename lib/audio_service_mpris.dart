import 'dart:async';
import 'dart:developer' as developer;
import 'dart:io';

import 'package:audio_service_platform_interface/audio_service_platform_interface.dart';
import 'package:dbus/dbus.dart';

part 'dbus_property.dart';
part 'defaults.dart';
part 'log_helper.dart';
part 'metadata.dart';
part 'mpris.dart';
part 'mpris_facade.dart';

class AudioServiceMpris extends AudioServicePlatform {
  late final DBusClient _dBusClient;
  late final _MprisMediaPlayer _mpris;
  AudioHandlerCallbacks? _handlerCallbacks;
  bool _isPlaying = false;

  static void registerWith() {
    AudioServicePlatform.instance = AudioServiceMpris();
  }

  static bool _enableLogging = false;
  static bool get enableLogging => _enableLogging;

  static _Defaults _defaults = _Defaults();

  /// Initializes the MPRIS service with the specified configuration.
  ///
  /// Call this method before [AudioService.init()] to configure MPRIS properties
  /// that are not managed by the `audio_service` package.
  ///
  /// ## Parameters
  ///
  /// ### Basic Configuration
  /// - [dBusName]: The D-Bus name for the media player (default: `'audio_service'`).
  ///   Used to form the full D-Bus name: `org.mpris.MediaPlayer2.<dBusName>.instance<PID>`.
  /// - [enableLogging]: If `true`, enables debug logging for MPRIS events (default: `false`).
  /// - [identity]: A friendly name to identify the media player (default: `'My Audio Player'`).
  ///   This name is displayed in media controls on KDE Plasma, GNOME, etc.
  /// - [desktopEntry]: The basename of an installed `.desktop` file without the extension
  ///   (default: `''`). Example: `'com.example.music'` for `/usr/share/applications/com.example.music.desktop`.
  ///
  /// ### Capability Flags
  /// These properties inform MPRIS clients about the capabilities of your media player.
  ///
  /// - [canControl]: Whether the media player can be controlled via MPRIS (default: `false`).
  ///   **Important:** If `false`, all other capability flags (`canPlay`, `canPause`, `canGoNext`,
  ///   `canGoPrevious`) will be forced to `false` regardless of their values.
  /// - [canPlay]: Whether playback can be started (default: `false`). Requires `canControl: true`.
  /// - [canPause]: Whether playback can be paused (default: `false`). Requires `canControl: true`.
  /// - [canGoNext]: Whether the Next method is supported (default: `false`). Requires `canControl: true`.
  /// - [canGoPrevious]: Whether the Previous method is supported (default: `false`). Requires `canControl: true`.
  /// - [fullscreen]: Whether the media player is in fullscreen mode (default: `false`).
  ///   Typically used for video players.
  /// - [canSetFullscreen]: Whether fullscreen mode can be toggled via MPRIS (default: `false`).
  ///
  /// ### Playback Configuration
  /// - [minimumRate]: Minimum playback rate (default: `1.0`). Must be ≤ 1.0.
  /// - [maximumRate]: Maximum playback rate (default: `1.0`). Must be ≥ 1.0.
  /// - [supportedUriSchemes]: List of supported URI schemes (e.g., ['file', 'http', 'rtsp']).
  ///   Default is empty list.
  /// - [supportedMimeTypes]: List of supported MIME types (e.g., ['audio/mpeg', 'application/ogg']).
  ///   Default is empty list.
  ///
  /// ### Callbacks
  /// - [onQuitRequest]: Callback invoked when the D-Bus `Quit()` method is called.
  ///   If provided, [canQuit] is automatically set to `true`.
  /// - [onRaiseRequest]: Callback invoked when the D-Bus `Raise()` method is called.
  ///   If provided, [canRaise] is automatically set to `true`.
  ///
  /// ## Returns
  /// Returns a [Mpris] instance for runtime property updates. You can use this object
  /// to change MPRIS properties after initialization.
  ///
  /// ## Example
  /// ```dart
  /// void main() async {
  ///   // Initialize MPRIS with custom configuration
  ///   AudioServiceMpris.init(
  ///     dBusName: 'MyMusicPlayer',
  ///     identity: 'My Music Player',
  ///     desktopEntry: 'com.example.music',
  ///     canControl: true,  // Required for canPlay/canPause/canGoNext/canGoPrevious
  ///     canPlay: true,
  ///     canPause: true,
  ///     canGoNext: true,
  ///     canGoPrevious: true,
  ///     minimumRate: 0.5,
  ///     maximumRate: 2.0,
  ///     onQuitRequest: () {
  ///       // Handle quit request from media controller
  ///       print('Quit requested via D-Bus');
  ///     },
  ///     onRaiseRequest: () {
  ///       // Handle raise request (bring window to front)
  ///       print('Raise requested via D-Bus');
  ///     },
  ///   );
  ///
  ///   // Initialize audio_service
  ///   await AudioService.init(
  ///     builder: () => YourAudioHandler(),
  ///     config: const AudioServiceConfig(
  ///       androidNotificationChannelId: 'com.example.app.audio',
  ///       androidNotificationChannelName: 'Audio playback',
  ///     ),
  ///   );
  ///
  ///   runApp(MyApp());
  /// }
  /// ```
  ///
  /// ## Runtime Property Updates
  /// Use the returned [Mpris] instance to update properties at runtime:
  /// ```dart
  /// final mpris = AudioServiceMpris.init(identity: 'My Player');
  /// // ... later in your code ...
  /// mpris.canGoNext = true;
  /// mpris.canGoPrevious = true;
  /// mpris.identity = 'Updated Name';
  /// ```
  ///
  /// Or create a new [Mpris] instance (singleton pattern):
  /// ```dart
  /// final mpris = Mpris();
  /// mpris.minimumRate = 0.5;
  /// mpris.maximumRate = 2.0;
  /// ```
  ///
  /// ## Important Notes
  /// - This method **must** be called before [AudioService.init()].
  /// - The [canControl] flag must be `true` for `canPlay`, `canPause`, `canGoNext`,
  ///   and `canGoPrevious` to take effect.
  /// - Callbacks [onQuitRequest] and [onRaiseRequest] automatically set the
  ///   corresponding `CanQuit` and `CanRaise` properties to `true`.
  /// - All parameters are optional.
  static Mpris init({
    String dBusName = 'audio_service',
    bool enableLogging = false,
    bool fullscreen = false,
    bool canSetFullscreen = false,
    String identity = 'My Audio Player',
    String desktopEntry = '',
    List<String>? supportedUriSchemes,
    List<String>? supportedMimeTypes,
    double minimumRate = 1.0,
    double maximumRate = 1.0,
    bool canGoNext = false,
    bool canGoPrevious = false,
    bool canPlay = false,
    bool canPause = false,
    bool canControl = false,
    void Function()? onQuitRequest,
    void Function()? onRaiseRequest,
  }) {
    _enableLogging = enableLogging;
    _defaults = _Defaults(
      dBusName: dBusName,
      fullscreen: fullscreen,
      canSetFullscreen: canSetFullscreen,
      identity: identity,
      desktopEntry: desktopEntry,
      supportedUriSchemes: supportedUriSchemes,
      supportedMimeTypes: supportedMimeTypes,
      minimumRate: minimumRate,
      maximumRate: maximumRate,
      canGoNext: canControl && canGoNext,
      canGoPrevious: canControl && canGoPrevious,
      canPlay: canControl && canPlay,
      canPause: canControl && canPause,
      canControl: canControl,
      onQuitRequest: onQuitRequest,
      onRaiseRequest: onRaiseRequest,
    );

    return Mpris();
  }

  @override
  Future<void> configure(ConfigureRequest request) async {
    _dBusClient = DBusClient.session();
    _mpris = _MprisMediaPlayer();

    _listenToEvents();
    _listenToPropertyChanges();
    _listenToMethodEvents();

    await _dBusClient.registerObject(_mpris);
    await _dBusClient.requestName(
      'org.mpris.MediaPlayer2.${_defaults.dBusName}.instance$pid',
      flags: {DBusRequestNameFlag.doNotQueue},
    );
    _mpris.identity = _defaults.identity;
  }

  @override
  Future<void> setState(SetStateRequest request) async {
    _mpris.position = request.state.updatePosition;
    _isPlaying = request.state.playing;
    _mpris.playbackState = _isPlaying ? 'Playing' : 'Paused';
    _mpris.shuffle = request.state.shuffleMode != AudioServiceShuffleModeMessage.none;
    _mpris.loopStatus = _loopStatuses.keys.firstWhere(
      (k) => _loopStatuses[k] == request.state.repeatMode,
      orElse: () => 'None',
    );
    _mpris.rate = request.state.speed;
  }

  @override
  Future<void> setMediaItem(SetMediaItemRequest request) async {
    List<String>? artist;
    if (request.mediaItem.artist != null) artist = [request.mediaItem.artist!];

    List<String>? genre;
    if (request.mediaItem.genre != null) genre = [request.mediaItem.genre!];

    _mpris.metadata = _Metadata(
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
  void setHandlerCallbacks(AudioHandlerCallbacks callbacks) {
    _handlerCallbacks = callbacks;
  }

  static final Map<String, AudioServiceRepeatModeMessage> _loopStatuses = {
    'Track': AudioServiceRepeatModeMessage.one,
    'Playlist': AudioServiceRepeatModeMessage.all,
    'None': AudioServiceRepeatModeMessage.none
  };

  void _listenToEvents() {
    _mpris.events.listen((event) {
      if (_handlerCallbacks == null) return;

      switch (event.type) {
        case _MprisEventType.controlPlay:
          _handlerCallbacks!.play(const PlayRequest());
        case _MprisEventType.controlPause:
          _handlerCallbacks!.pause(const PauseRequest());
        case _MprisEventType.controlNext:
          _handlerCallbacks!.skipToNext(const SkipToNextRequest());
        case _MprisEventType.controlPrevious:
          _handlerCallbacks!.skipToPrevious(const SkipToPreviousRequest());
        case _MprisEventType.controlPlayPause:
          _isPlaying
              ? _handlerCallbacks!.pause(const PauseRequest())
              : _handlerCallbacks!.play(const PlayRequest());
        case _MprisEventType.controlStop:
          _handlerCallbacks!.stop(const StopRequest());
        case _MprisEventType.position:
          _handlerCallbacks!.seek(SeekRequest(position: event.value as Duration));
        case _MprisEventType.openUri:
          _handlerCallbacks!.playFromUri(PlayFromUriRequest(uri: event.value as Uri));
      }
    });
  }

  void _listenToPropertyChanges() {
    _mpris.propertyEvents.listen((event) {
      if (_handlerCallbacks == null) return;

      switch (event.name) {
        case 'Shuffle':
          final value = event.value as bool;
          final modeMessage =
              value ? AudioServiceShuffleModeMessage.all : AudioServiceShuffleModeMessage.none;
          final request = SetShuffleModeRequest(shuffleMode: modeMessage);
          _handlerCallbacks!.setShuffleMode(request);
        case 'Rate':
          final value = event.value as double;
          final request = SetSpeedRequest(speed: value);
          _handlerCallbacks!.setSpeed(request);
        case 'LoopStatus':
          final value = event.value as String;
          final repeatMode = _loopStatuses[value] ?? AudioServiceRepeatModeMessage.none;
          final request = SetRepeatModeRequest(repeatMode: repeatMode);
          _handlerCallbacks!.setRepeatMode(request);
        case 'PlaybackStatus':
          final value = event.value as String;
          if (value == 'Playing') {
            _handlerCallbacks!.play(const PlayRequest());
          } else if (value == 'Paused') {
            _handlerCallbacks!.pause(const PauseRequest());
          } else if (value == 'Stopped') {
            _handlerCallbacks!.stop(const StopRequest());
          }
        case 'Volume':
          final value = event.value as double;
          final req = CustomActionRequest(name: 'dbusVolume', extras: {'value': value});
          _handlerCallbacks!.customAction(req);
      }
    });
  }

  void _listenToMethodEvents() {
    _mpris.methodEvents.listen((method) {
      switch (method) {
        case _MprisMethod.quit:
          if (_defaults.onQuitRequest != null) _defaults.onQuitRequest!.call();
        case _MprisMethod.raise:
          if (_defaults.onRaiseRequest != null) _defaults.onRaiseRequest!.call();
      }
    });
  }
}
