import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(PigeonOptions(
  dartOut: 'lib/src/lockbox_api.g.dart',
  dartOptions: DartOptions(),
  kotlinOut: 'android/src/main/kotlin/com/lockbox/sdk/flutter_lockbox/LockboxApi.g.kt',
  kotlinOptions: KotlinOptions(package: 'com.lockbox.sdk.flutter_lockbox'),
  swiftOut: 'ios/Classes/LockboxApi.g.swift',
  swiftOptions: SwiftOptions(),
))

@HostApi()
abstract class LockboxHostApi {
  bool saveSecureString(String key, String value);
  String? getSecureString(String key);
  bool deleteSecureString(String key);
}
