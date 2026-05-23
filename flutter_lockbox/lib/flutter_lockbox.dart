import 'src/lockbox_api.g.dart';

/**
 * FlutterLockbox Plugin API
 * Provides hardware-encrypted secure storage (Android KeyStore & iOS Keychain).
 */
class FlutterLockbox {
  final LockboxHostApi _api = LockboxHostApi();

  /**
   * Encrypts and stores a string value under the given key.
   */
  Future<bool> saveSecureString(String key, String value) {
    return _api.saveSecureString(key, value);
  }

  /**
   * Retrieves and decrypts a stored string value. Returns null if not found.
   */
  Future<String?> getSecureString(String key) {
    return _api.getSecureString(key);
  }

  /**
   * Deletes a stored secure credential.
   */
  Future<bool> deleteSecureString(String key) {
    return _api.deleteSecureString(key);
  }
}
