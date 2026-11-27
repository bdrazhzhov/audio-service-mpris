import 'package:audio_service_mpris/audio_service_mpris.dart';
import 'package:audio_service_platform_interface/audio_service_platform_interface.dart';
import 'package:dbus/dbus.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeDBusClient implements DBusClient {
  _FakeDBusClient({this.failOnRequestName = false});

  final bool failOnRequestName;
  final List<DBusObject> registeredObjects = [];
  final List<DBusObject> unregisteredObjects = [];
  final List<String> requestedNames = [];
  final List<String> releasedNames = [];
  bool closed = false;

  @override
  Future<void> registerObject(DBusObject object) async {
    registeredObjects.add(object);
  }

  @override
  Future<void> unregisterObject(DBusObject object) async {
    unregisteredObjects.add(object);
  }

  @override
  Future<DBusRequestNameReply> requestName(
    String name, {
    Set<DBusRequestNameFlag> flags = const {},
  }) async {
    if (failOnRequestName) {
      throw StateError('Simulated D-Bus requestName failure');
    }
    requestedNames.add(name);
    return DBusRequestNameReply.primaryOwner;
  }

  @override
  Future<DBusReleaseNameReply> releaseName(String name) async {
    releasedNames.add(name);
    return DBusReleaseNameReply.released;
  }

  @override
  Future<void> close() async {
    closed = true;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeHandlerCallbacks implements AudioHandlerCallbacks {
  int playCount = 0;

  @override
  Future<void> play(PlayRequest request) async {
    playCount++;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  ConfigureRequest makeConfigureRequest() => ConfigureRequest(
        config: AudioServiceConfigMessage(
          androidNotificationChannelId: 'com.example.audio',
          androidNotificationChannelName: 'Audio',
        ),
      );

  DBusMethodCall makePlayCall() => DBusMethodCall(
        sender: 'test.sender',
        interface: 'org.mpris.MediaPlayer2.Player',
        name: 'Play',
        values: const [],
      );

  test('dispose releases name, unregisters object, closes client, and stops events',
      () async {
    final client = _FakeDBusClient();
    final callbacks = _FakeHandlerCallbacks();
    final plugin = AudioServiceMpris(dBusClientFactory: () => client);

    plugin.setHandlerCallbacks(callbacks);
    await plugin.configure(makeConfigureRequest());

    expect(client.registeredObjects, hasLength(1));
    expect(client.requestedNames, hasLength(1));

    final mprisObject = client.registeredObjects.single;
    await mprisObject.handleMethodCall(makePlayCall());
    await Future<void>.delayed(Duration.zero);
    expect(callbacks.playCount, 1);

    await plugin.dispose();

    expect(client.releasedNames, equals(client.requestedNames));
    expect(client.unregisteredObjects, equals(client.registeredObjects));
    expect(client.closed, isTrue);

    await mprisObject.handleMethodCall(makePlayCall());
    await Future<void>.delayed(Duration.zero);
    expect(callbacks.playCount, 1);
  });

  test('re-calling configure tears down previous client without duplicating listeners',
      () async {
    final clients = <_FakeDBusClient>[];
    final callbacks = _FakeHandlerCallbacks();
    final plugin = AudioServiceMpris(
      dBusClientFactory: () {
        final client = _FakeDBusClient();
        clients.add(client);
        return client;
      },
    );

    plugin.setHandlerCallbacks(callbacks);
    await plugin.configure(makeConfigureRequest());
    await plugin.configure(makeConfigureRequest());

    expect(clients, hasLength(2));
    expect(clients[0].closed, isTrue);
    expect(clients[0].unregisteredObjects, hasLength(1));
    expect(clients[1].closed, isFalse);

    final mprisObject = clients[1].registeredObjects.single;
    await mprisObject.handleMethodCall(makePlayCall());
    await Future<void>.delayed(Duration.zero);
    expect(callbacks.playCount, 1);

    await plugin.dispose();
    expect(clients[1].closed, isTrue);
  });

  test('configure failure cleans up client and cancels subscriptions', () async {
    final client = _FakeDBusClient(failOnRequestName: true);
    final callbacks = _FakeHandlerCallbacks();
    final plugin = AudioServiceMpris(dBusClientFactory: () => client);

    plugin.setHandlerCallbacks(callbacks);
    await expectLater(
      plugin.configure(makeConfigureRequest()),
      throwsA(isA<StateError>()),
    );

    expect(client.unregisteredObjects, equals(client.registeredObjects));
    expect(client.closed, isTrue);

    final mprisObject = client.registeredObjects.single;
    await mprisObject.handleMethodCall(makePlayCall());
    await Future<void>.delayed(Duration.zero);
    expect(callbacks.playCount, 0);
  });
}
