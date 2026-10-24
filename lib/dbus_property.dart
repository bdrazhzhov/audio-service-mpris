part of 'audio_service_mpris.dart';

enum PropertyChangeNotification { emits, silent, invalidates, constant }

class _PropertyEvent {
  final String name;
  final Object value;
  const _PropertyEvent(this.name, this.value);
}

class _DBusProperty<T extends Object> {
  final String name;
  final String interfaceName;
  final DBusSignature signature = DBusSignature(_getSignature<T>());
  final bool readOnly;
  final PropertyChangeNotification changeNotification;
  T _value;

  static final DBusObject _mpris = _MprisMediaPlayer();
  static final _eventStreamController = StreamController<_PropertyEvent>.broadcast();
  static Stream<_PropertyEvent> get events => _eventStreamController.stream;

  _DBusProperty({
    required this.name,
    required this.interfaceName,
    required T initialValue,
    this.readOnly = true,
    this.changeNotification = PropertyChangeNotification.emits,
  }) : _value = initialValue;

  void _setValue(T newValue) {
    if (_value == newValue) return;

    _value = newValue;
    switch (changeNotification) {
      case PropertyChangeNotification.emits:
        _mpris.emitPropertiesChanged(
          interfaceName,
          changedProperties: {name: _toDbusValue(newValue)},
        );
      case PropertyChangeNotification.invalidates:
        _mpris.emitPropertiesChanged(interfaceName, invalidatedProperties: [name]);
      default:
    }
  }

  T get value => _value;

  set value(T newValue) => _setValue(newValue);

  DBusMethodResponse setFromDbus(DBusValue value) {
    if (value.signature != signature) {
      return DBusMethodErrorResponse.invalidArgs();
    }

    if (readOnly) {
      return DBusMethodErrorResponse.propertyReadOnly();
    }

    final newValue = _fromDbusValue(value) as T;
    _setValue(newValue);
    _eventStreamController.add(_PropertyEvent(name, _value));

    return DBusMethodSuccessResponse([]);
  }

  DBusValue toDbusValue() => _toDbusValue(_value);

  late final DBusIntrospectProperty _introspection = DBusIntrospectProperty(
    name,
    signature,
    access: readOnly ? DBusPropertyAccess.read : DBusPropertyAccess.readwrite,
    annotations: [
      DBusIntrospectAnnotation(
        'org.freedesktop.DBus.Property.EmitsChangedSignal',
        switch (changeNotification) {
          PropertyChangeNotification.emits => 'true',
          PropertyChangeNotification.silent => 'false',
          PropertyChangeNotification.invalidates => 'invalidates',
          PropertyChangeNotification.constant => 'const',
        },
      ),
    ],
  );
  DBusIntrospectProperty get introspection => _introspection;
}

DBusValue _toDbusValue(Object value) {
  if (value is String) {
    return DBusString(value);
  } else if (value is int) {
    return DBusInt64(value);
  } else if (value is double) {
    return DBusDouble(value);
  } else if (value is bool) {
    return DBusBoolean(value);
  } else if (value is Duration) {
    return DBusInt64(value.inMicroseconds);
  } else if (value is List<String>) {
    return DBusArray(DBusSignature('s'), value.map((e) => DBusString(e)).toList());
  } else if (value is List<int>) {
    return DBusArray(DBusSignature('i'), value.map((e) => DBusInt64(e)).toList());
  } else if (value is List<double>) {
    return DBusArray(DBusSignature('d'), value.map((e) => DBusDouble(e)).toList());
  } else if (value is List<bool>) {
    return DBusArray(DBusSignature('b'), value.map((e) => DBusBoolean(e)).toList());
  } else if (value is _Metadata) {
    return value.toValue();
  } else {
    throw ArgumentError('Unsupported type for D-Bus value: ${value.runtimeType}');
  }
}

Object _fromDbusValue(DBusValue value) {
  if (value is DBusString) {
    return value.value;
  } else if (value is DBusInt64) {
    return value.value;
  } else if (value is DBusDouble) {
    return value.value;
  } else if (value is DBusBoolean) {
    return value.value;
  } else if (value is DBusArray) {
    if (value.signature == DBusSignature('s')) {
      return value.children.map((e) => (e as DBusString).value).toList();
    } else if (value.signature == DBusSignature('i')) {
      return value.children.map((e) => (e as DBusInt64).value).toList();
    } else if (value.signature == DBusSignature('d')) {
      return value.children.map((e) => (e as DBusDouble).value).toList();
    } else if (value.signature == DBusSignature('b')) {
      return value.children.map((e) => (e as DBusBoolean).value).toList();
    }
  }

  throw ArgumentError('Unsupported D-Bus value type: ${value.runtimeType}');
}

String _getSignature<T>() {
  if (T == String) {
    return 's';
  } else if (T == int) {
    return 'x';
  } else if (T == double) {
    return 'd';
  } else if (T == bool) {
    return 'b';
  } else if (T == Duration) {
    return 'x';
  } else if (T == List<String>) {
    return 'as';
  } else if (T == List<int>) {
    return 'ax';
  } else if (T == List<double>) {
    return 'ad';
  } else if (T == List<bool>) {
    return 'ab';
  } else if (T == _Metadata) {
    return 'a{sv}';
  } else {
    throw ArgumentError('Unsupported type for D-Bus signature: ${T.toString()}');
  }
}
