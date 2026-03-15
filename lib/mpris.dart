part of 'audio_service_mpris.dart';

enum _MprisEventType {
  controlPlay,
  controlPause,
  controlNext,
  controlPrevious,
  controlPlayPause,
  controlStop,
  openUri,
  position,
}

enum _MprisMethod { quit, raise }

class _MprisEvent {
  final _MprisEventType type;
  final Object? value;
  const _MprisEvent(this.type, this.value);
}

class _MethodHandler {
  final String signature;
  final Future<DBusMethodResponse> Function(DBusMethodCall call) handler;
  const _MethodHandler(this.handler, {this.signature = ''});
}

class _MprisMediaPlayer extends DBusObject {
  final _eventStreamController = StreamController<_MprisEvent>.broadcast();
  Stream<_MprisEvent> get events => _eventStreamController.stream;

  final _methodEventStreamController = StreamController<_MprisMethod>.broadcast();
  Stream<_MprisMethod> get methodEvents => _methodEventStreamController.stream;

  _MprisMediaPlayer._() : super(DBusObjectPath('/org/mpris/MediaPlayer2'));
  static final _MprisMediaPlayer _instance = _MprisMediaPlayer._();

  factory _MprisMediaPlayer() {
    return _instance;
  }

  Stream<_PropertyEvent> get propertyEvents => _DBusProperty.events;

  late final Map<String, _MethodHandler> _mediaPlayer2Handlers = Map.unmodifiable({
    'Raise': _MethodHandler((_) => _doRaise()),
    'Quit': _MethodHandler((_) => _doQuit()),
  });

  late final Map<String, _MethodHandler> _playerHandlers = Map.unmodifiable({
    'Next': _MethodHandler((_) => _doNext()),
    'Previous': _MethodHandler((_) => _doPrevious()),
    'Pause': _MethodHandler((_) => _doPause()),
    'PlayPause': _MethodHandler((_) => _doPlayPause()),
    'Stop': _MethodHandler((_) => _doStop()),
    'Play': _MethodHandler((_) => doPlay()),
    'Seek': _MethodHandler((call) => _doSeek(call.values[0].asInt64()), signature: 'x'),
    'SetPosition': _MethodHandler(
        (call) =>
            _doSetPosition(call.values[0].asObjectPath().toString(), call.values[1].asInt64()),
        signature: 'ox'),
    'OpenUri': _MethodHandler((call) => _doOpenUri(call.values[0].asString()), signature: 's'),
  });

  late final Map<String, _DBusProperty> _mediaPlayer2Properties = Map.unmodifiable({
    'CanQuit': _canQuitProperty,
    'Fullscreen': _fullscreenProperty,
    'CanSetFullscreen': _canSetFullscreenProperty,
    'CanRaise': _canRaiseProperty,
    'HasTrackList': _hasTrackListProperty,
    'Identity': _identityProperty,
    'DesktopEntry': _desktopEntryProperty,
    'SupportedUriSchemes': _supportedUriSchemesProperty,
    'SupportedMimeTypes': _supportedMimeTypesProperty,
  });

  late final Map<String, _DBusProperty> _playerProperties = Map.unmodifiable({
    'PlaybackStatus': _playbackStatusProperty,
    'LoopStatus': _loopStatusProperty,
    'Rate': _rateProperty,
    'Shuffle': _shuffleProperty,
    'Metadata': _metadataProperty,
    'Volume': _volumeProperty,
    'Position': _positionProperty,
    'MinimumRate': _minimumRateProperty,
    'MaximumRate': _maximumRateProperty,
    'CanGoNext': _canGoNextProperty,
    'CanGoPrevious': _canGoPreviousProperty,
    'CanPlay': _canPlayProperty,
    'CanPause': _canPauseProperty,
    'CanSeek': _canSeekProperty,
    'CanControl': _canControlProperty,
  });

  final _identityProperty = _DBusProperty<String>(
    name: 'Identity',
    interfaceName: 'org.mpris.MediaPlayer2',
    initialValue: AudioServiceMpris._defaults.identity,
    readOnly: true,
  );
  String get identity => _identityProperty.value;
  set identity(String value) => _identityProperty.value = value;

  final _canQuitProperty = _DBusProperty<bool>(
    name: 'CanQuit',
    interfaceName: 'org.mpris.MediaPlayer2',
    initialValue: AudioServiceMpris._defaults.onQuitRequest != null,
  );

  bool get canQuit => _canQuitProperty.value;
  set canQuit(bool value) => _canQuitProperty.value = value;

  final _fullscreenProperty = _DBusProperty<bool>(
    name: 'Fullscreen',
    interfaceName: 'org.mpris.MediaPlayer2',
    initialValue: false,
    readOnly: false,
  );

  bool get fullscreen => _fullscreenProperty.value;
  set fullscreen(bool value) => _fullscreenProperty.value = value;

  final _canSetFullscreenProperty = _DBusProperty<bool>(
    name: 'CanSetFullscreen',
    interfaceName: 'org.mpris.MediaPlayer2',
    initialValue: false,
  );

  bool get canSetFullscreen => _canSetFullscreenProperty.value;
  set canSetFullscreen(bool value) => _canSetFullscreenProperty.value = value;

  final _canRaiseProperty = _DBusProperty<bool>(
    name: 'CanRaise',
    interfaceName: 'org.mpris.MediaPlayer2',
    initialValue: AudioServiceMpris._defaults.onRaiseRequest != null,
  );

  bool get canRaise => _canRaiseProperty.value;
  set canRaise(bool value) => _canRaiseProperty.value = value;

  final _hasTrackListProperty = _DBusProperty<bool>(
    name: 'HasTrackList',
    interfaceName: 'org.mpris.MediaPlayer2',
    initialValue: false,
  );

  bool get hasTrackList => _hasTrackListProperty.value;
  set hasTrackList(bool value) => _hasTrackListProperty.value = value;

  final _desktopEntryProperty = _DBusProperty<String>(
    name: 'DesktopEntry',
    interfaceName: 'org.mpris.MediaPlayer2',
    initialValue: '',
  );

  String get desktopEntry => _desktopEntryProperty.value;
  set desktopEntry(String value) => _desktopEntryProperty.value = value;

  final _supportedUriSchemesProperty = _DBusProperty<List<String>>(
    name: 'SupportedUriSchemes',
    interfaceName: 'org.mpris.MediaPlayer2',
    initialValue: [],
  );

  List<String> get supportedUriSchemes => _supportedUriSchemesProperty.value;
  set supportedUriSchemes(List<String> value) => _supportedUriSchemesProperty.value = value;

  final _supportedMimeTypesProperty = _DBusProperty<List<String>>(
    name: 'SupportedMimeTypes',
    interfaceName: 'org.mpris.MediaPlayer2',
    initialValue: [],
  );

  List<String> get supportedMimeTypes => _supportedMimeTypesProperty.value;
  set supportedMimeTypes(List<String> value) => _supportedMimeTypesProperty.value = value;

  final _playbackStatusProperty = _DBusProperty<String>(
    name: 'PlaybackStatus',
    interfaceName: 'org.mpris.MediaPlayer2.Player',
    initialValue: 'Stopped',
  );

  String get playbackState => _playbackStatusProperty.value;
  set playbackState(String state) => _playbackStatusProperty.value = state;

  final _loopStatusProperty = _DBusProperty<String>(
    name: 'LoopStatus',
    interfaceName: 'org.mpris.MediaPlayer2.Player',
    initialValue: 'None',
    readOnly: false,
  );

  String get loopStatus => _loopStatusProperty.value;
  set loopStatus(String newValue) => _loopStatusProperty.value = newValue;

  final _rateProperty = _DBusProperty<double>(
    name: 'Rate',
    interfaceName: 'org.mpris.MediaPlayer2.Player',
    initialValue: 1.0,
    readOnly: false,
  );

  double get rate => _rateProperty.value;
  set rate(double newValue) => _rateProperty.value = newValue;

  final _shuffleProperty = _DBusProperty<bool>(
    name: 'Shuffle',
    interfaceName: 'org.mpris.MediaPlayer2.Player',
    initialValue: false,
    readOnly: false,
  );

  bool get shuffle => _shuffleProperty.value;
  set shuffle(bool newValue) => _shuffleProperty.value = newValue;

  final _metadataProperty = _DBusProperty<_Metadata>(
    name: 'Metadata',
    interfaceName: 'org.mpris.MediaPlayer2.Player',
    initialValue: _Metadata(title: 'No title'),
  );

  _Metadata get metadata => _metadataProperty.value;
  set metadata(_Metadata metadata) => _metadataProperty.value = metadata;

  final _minimumRateProperty = _DBusProperty<double>(
    name: 'MinimumRate',
    interfaceName: 'org.mpris.MediaPlayer2.Player',
    initialValue: 1.0,
  );

  double get minimumRate => _minimumRateProperty.value;
  set minimumRate(double value) => _minimumRateProperty.value = value;

  final _maximumRateProperty = _DBusProperty<double>(
    name: 'MaximumRate',
    interfaceName: 'org.mpris.MediaPlayer2.Player',
    initialValue: 1.0,
  );

  double get maximumRate => _maximumRateProperty.value;
  set maximumRate(double value) => _maximumRateProperty.value = value;

  final _canGoNextProperty = _DBusProperty<bool>(
    name: 'CanGoNext',
    interfaceName: 'org.mpris.MediaPlayer2.Player',
    initialValue: AudioServiceMpris._defaults.canGoNext,
  );

  bool get canGoNext => _canGoNextProperty.value;
  set canGoNext(bool value) => _canGoNextProperty.value = value;

  final _canGoPreviousProperty = _DBusProperty<bool>(
    name: 'CanGoPrevious',
    interfaceName: 'org.mpris.MediaPlayer2.Player',
    initialValue: AudioServiceMpris._defaults.canGoPrevious,
  );

  bool get canGoPrevious => _canGoPreviousProperty.value;
  set canGoPrevious(bool value) => _canGoPreviousProperty.value = value;

  final _canPlayProperty = _DBusProperty<bool>(
    name: 'CanPlay',
    interfaceName: 'org.mpris.MediaPlayer2.Player',
    initialValue: AudioServiceMpris._defaults.canPlay,
  );

  bool get canPlay => _canPlayProperty.value;
  set canPlay(bool value) => _canPlayProperty.value = value;

  final _canPauseProperty = _DBusProperty<bool>(
    name: 'CanPause',
    interfaceName: 'org.mpris.MediaPlayer2.Player',
    initialValue: AudioServiceMpris._defaults.canPause,
  );

  bool get canPause => _canPauseProperty.value;
  set canPause(bool value) => _canPauseProperty.value = value;

  final _canSeekProperty = _DBusProperty<bool>(
    name: 'CanSeek',
    interfaceName: 'org.mpris.MediaPlayer2.Player',
    initialValue: false,
  );

  bool get canSeek => _canSeekProperty.value;
  set canSeek(bool value) => _canSeekProperty.value = value;

  final _canControlProperty = _DBusProperty<bool>(
    name: 'CanControl',
    interfaceName: 'org.mpris.MediaPlayer2.Player',
    initialValue: AudioServiceMpris._defaults.canControl,
  );

  bool get canControl => _canControlProperty.value;
  set canControl(bool value) => _canControlProperty.value = value;

  final _volumeProperty = _DBusProperty<double>(
    name: 'Volume',
    interfaceName: 'org.mpris.MediaPlayer2.Player',
    initialValue: 1.0,
    readOnly: false,
  );

  double get volume => _volumeProperty.value;
  set volume(double value) => _volumeProperty.value = value;

  final _positionProperty = _DBusProperty<Duration>(
    name: 'Position',
    interfaceName: 'org.mpris.MediaPlayer2.Player',
    initialValue: Duration.zero,
  );

  Duration get position => _positionProperty.value;
  set position(Duration value) => _positionProperty.value = value;

  void _emitEvent(_MprisEventType type, [Object? value]) {
    _eventStreamController.add(_MprisEvent(type, value));
  }

  void _emitMethodEvent(_MprisMethod method) {
    _methodEventStreamController.add(method);
  }

  /// Implementation of org.mpris.MediaPlayer2.Raise()
  Future<DBusMethodResponse> _doRaise() async {
    _emitMethodEvent(_MprisMethod.raise);
    return DBusMethodSuccessResponse([]);
  }

  /// Implementation of org.mpris.MediaPlayer2.Quit()
  Future<DBusMethodResponse> _doQuit() async {
    _emitMethodEvent(_MprisMethod.quit);
    return DBusMethodSuccessResponse([]);
  }

  /// Implementation of org.mpris.MediaPlayer2.Player.Next()
  Future<DBusMethodResponse> _doNext() async {
    _emitEvent(_MprisEventType.controlNext);
    return DBusMethodSuccessResponse([]);
  }

  /// Implementation of org.mpris.MediaPlayer2.Player.Previous()
  Future<DBusMethodResponse> _doPrevious() async {
    _emitEvent(_MprisEventType.controlPrevious);
    return DBusMethodSuccessResponse([]);
  }

  /// Implementation of org.mpris.MediaPlayer2.Player.Pause()
  Future<DBusMethodResponse> _doPause() async {
    _emitEvent(_MprisEventType.controlPause);
    return DBusMethodSuccessResponse([]);
  }

  /// Implementation of org.mpris.MediaPlayer2.Player.PlayPause()
  Future<DBusMethodResponse> _doPlayPause() async {
    _emitEvent(_MprisEventType.controlPlayPause);
    return DBusMethodSuccessResponse([]);
  }

  /// Implementation of org.mpris.MediaPlayer2.Player.Stop()
  Future<DBusMethodResponse> _doStop() async {
    _emitEvent(_MprisEventType.controlStop);
    return DBusMethodSuccessResponse([]);
  }

  /// Implementation of org.mpris.MediaPlayer2.Player.Play()
  Future<DBusMethodResponse> doPlay() async {
    _emitEvent(_MprisEventType.controlPlay);
    return DBusMethodSuccessResponse([]);
  }

  /// Implementation of org.mpris.MediaPlayer2.Player.Seek()
  Future<DBusMethodResponse> _doSeek(int offset) async {
    return DBusMethodSuccessResponse([]);
  }

  /// Implementation of org.mpris.MediaPlayer2.Player.SetPosition()
  Future<DBusMethodResponse> _doSetPosition(String trackId, int position) async {
    _emitEvent(_MprisEventType.position, Duration(microseconds: position));
    return DBusMethodSuccessResponse([]);
  }

  /// Implementation of org.mpris.MediaPlayer2.Player.OpenUri()
  Future<DBusMethodResponse> _doOpenUri(String uri) async {
    _emitEvent(_MprisEventType.openUri, Uri.parse(uri));
    return DBusMethodSuccessResponse([]);
  }

  @override
  List<DBusIntrospectInterface> introspect() {
    return [
      DBusIntrospectInterface('org.mpris.MediaPlayer2',
          methods: [DBusIntrospectMethod('Raise'), DBusIntrospectMethod('Quit')],
          properties: [
            _canQuitProperty,
            _fullscreenProperty,
            _canSetFullscreenProperty,
            _canRaiseProperty,
            _hasTrackListProperty,
            _identityProperty,
            _desktopEntryProperty,
            _supportedUriSchemesProperty,
            _supportedMimeTypesProperty,
          ].map((p) => p.introspection).toList()),
      DBusIntrospectInterface('org.mpris.MediaPlayer2.Player',
          methods: [
            DBusIntrospectMethod('Next'),
            DBusIntrospectMethod('Previous'),
            DBusIntrospectMethod('Pause'),
            DBusIntrospectMethod('PlayPause'),
            DBusIntrospectMethod('Stop'),
            DBusIntrospectMethod('Play'),
            DBusIntrospectMethod('Seek', args: [
              DBusIntrospectArgument(DBusSignature('x'), DBusArgumentDirection.in_, name: 'Offset')
            ]),
            DBusIntrospectMethod('SetPosition', args: [
              DBusIntrospectArgument(DBusSignature('o'), DBusArgumentDirection.in_,
                  name: 'TrackId'),
              DBusIntrospectArgument(DBusSignature('x'), DBusArgumentDirection.in_,
                  name: 'Position')
            ]),
            DBusIntrospectMethod('OpenUri', args: [
              DBusIntrospectArgument(DBusSignature('s'), DBusArgumentDirection.in_, name: 'Uri')
            ])
          ],
          signals: [
            DBusIntrospectSignal('Seeked', args: [
              DBusIntrospectArgument(DBusSignature('x'), DBusArgumentDirection.out,
                  name: 'Position')
            ])
          ],
          properties: [
            _playbackStatusProperty,
            _loopStatusProperty,
            _rateProperty,
            _shuffleProperty,
            _metadataProperty,
            _volumeProperty,
            _positionProperty,
            _minimumRateProperty,
            _maximumRateProperty,
            _canGoNextProperty,
            _canGoPreviousProperty,
            _canPlayProperty,
            _canPauseProperty,
            _canSeekProperty,
            _canControlProperty
          ].map((p) => p.introspection).toList())
    ];
  }

  @override
  Future<DBusMethodResponse> handleMethodCall(DBusMethodCall methodCall) async {
    Future<DBusMethodResponse> guardSignature(
        String signature, Future<DBusMethodResponse> Function(DBusMethodCall call) handler) async {
      if (methodCall.signature != DBusSignature(signature)) {
        return DBusMethodErrorResponse.invalidArgs();
      }
      return handler(methodCall);
    }

    if (methodCall.interface == 'org.mpris.MediaPlayer2') {
      final entry = _mediaPlayer2Handlers[methodCall.name];
      if (entry == null) {
        return DBusMethodErrorResponse.unknownMethod();
      }
      return guardSignature(entry.signature, entry.handler);
    }

    if (methodCall.interface == 'org.mpris.MediaPlayer2.Player') {
      final entry = _playerHandlers[methodCall.name];
      if (entry == null) {
        return DBusMethodErrorResponse.unknownMethod();
      }
      return guardSignature(entry.signature, entry.handler);
    }

    return DBusMethodErrorResponse.unknownInterface();
  }

  @override
  Future<DBusMethodResponse> getProperty(String interface, String name) async {
    _log('Requested property $name from $interface');

    if (interface == 'org.mpris.MediaPlayer2') {
      final property = _mediaPlayer2Properties[name];
      if (property == null) {
        return DBusMethodErrorResponse.unknownProperty();
      }
      return DBusMethodSuccessResponse([DBusVariant(property.toDbusValue())]);
    }

    if (interface == 'org.mpris.MediaPlayer2.Player') {
      final property = _playerProperties[name];
      if (property == null) {
        return DBusMethodErrorResponse.unknownProperty();
      }
      return DBusMethodSuccessResponse([DBusVariant(property.toDbusValue())]);
    }

    return DBusMethodErrorResponse.unknownInterface();
  }

  @override
  Future<DBusMethodResponse> setProperty(String interface, String name, DBusValue value) async {
    _log('Set property $name from $interface to $value');

    if (interface == 'org.mpris.MediaPlayer2') {
      final property = _mediaPlayer2Properties[name];
      if (property == null) {
        return DBusMethodErrorResponse.unknownProperty();
      }
      if (property.readOnly) {
        return DBusMethodErrorResponse.propertyReadOnly();
      }
      if (value.signature != property.signature) {
        return DBusMethodErrorResponse.invalidArgs();
      }
      return property.setFromDbus(value);
    }

    if (interface == 'org.mpris.MediaPlayer2.Player') {
      final property = _playerProperties[name];
      if (property == null) {
        return DBusMethodErrorResponse.unknownProperty();
      }
      if (property.readOnly) {
        return DBusMethodErrorResponse.propertyReadOnly();
      }
      if (value.signature != property.signature) {
        return DBusMethodErrorResponse.invalidArgs();
      }
      return property.setFromDbus(value);
    }

    return DBusMethodErrorResponse.unknownInterface();
  }

  @override
  Future<DBusMethodResponse> getAllProperties(String interface) async {
    Map<String, _DBusProperty>? properties;
    if (interface == 'org.mpris.MediaPlayer2') {
      properties = _mediaPlayer2Properties;
    } else if (interface == 'org.mpris.MediaPlayer2.Player') {
      properties = _playerProperties;
    }

    final values = <String, DBusValue>{};
    if (properties != null) {
      for (final entry in properties.entries) {
        values[entry.key] = entry.value.toDbusValue();
      }
    }

    return DBusMethodSuccessResponse([DBusDict.stringVariant(values)]);
  }
}
