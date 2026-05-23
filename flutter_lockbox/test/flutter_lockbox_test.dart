import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_lockbox/flutter_lockbox.dart';
import 'package:flutter_lockbox/flutter_lockbox_platform_interface.dart';
import 'package:flutter_lockbox/flutter_lockbox_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterLockboxPlatform
    with MockPlatformInterfaceMixin
    implements FlutterLockboxPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final FlutterLockboxPlatform initialPlatform = FlutterLockboxPlatform.instance;

  test('$MethodChannelFlutterLockbox is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterLockbox>());
  });

  test('getPlatformVersion', () async {
    FlutterLockbox flutterLockboxPlugin = FlutterLockbox();
    MockFlutterLockboxPlatform fakePlatform = MockFlutterLockboxPlatform();
    FlutterLockboxPlatform.instance = fakePlatform;

    expect(await flutterLockboxPlugin.getPlatformVersion(), '42');
  });
}
