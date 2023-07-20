import 'package:flutter_test/flutter_test.dart';
import 'package:audio_service_mpris/audio_service_mpris.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

// class MockAudioServiceMprisPlatform
//     with MockPlatformInterfaceMixin
//     implements AudioServiceMprisPlatform {
//
//   @override
//   Future<String?> getPlatformVersion() => Future.value('42');
// }
//
// void main() {
//   final AudioServiceMprisPlatform initialPlatform = AudioServiceMprisPlatform.instance;
//
//   test('$MethodChannelAudioServiceMpris is the default instance', () {
//     expect(initialPlatform, isInstanceOf<MethodChannelAudioServiceMpris>());
//   });
//
//   test('getPlatformVersion', () async {
//     AudioServiceMpris audioServiceMprisPlugin = AudioServiceMpris();
//     MockAudioServiceMprisPlatform fakePlatform = MockAudioServiceMprisPlatform();
//     AudioServiceMprisPlatform.instance = fakePlatform;
//
//     expect(await audioServiceMprisPlugin.getPlatformVersion(), '42');
//   });
// }
