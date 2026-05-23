import Flutter
import UIKit
import Lockbox

/**
 * FlutterLockboxPlugin
 * Bridges Flutter Pigeon calls to the native iOS Core Lockbox library.
 */
public class FlutterLockboxPlugin: NSObject, FlutterPlugin, LockboxHostApi {

  public static func register(with registrar: FlutterPluginRegistrar) {
    let instance = FlutterLockboxPlugin()
    LockboxHostApiSetup.setUp(binaryMessenger: registrar.messenger(), api: instance)
  }

  // --- LockboxHostApi protocol implementation ---

  public func saveSecureString(key: String, value: String) throws -> Bool {
    return Lockbox.shared.saveSecureString(key, value: value)
  }

  public func getSecureString(key: String) throws -> String? {
    return Lockbox.shared.getSecureString(key)
  }

  public func deleteSecureString(key: String) throws -> Bool {
    return Lockbox.shared.deleteSecureString(key)
  }
}
