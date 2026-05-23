import Foundation
import Security

/**
 * iOS Secure Storage Core (Lockbox).
 * Protects sensitive string data using the iOS Keychain Services API.
 */
@objc(Lockbox)
public final class Lockbox: NSObject {

    @objc
    public static let shared = Lockbox()

    private override init() {
        super.init()
    }

    /**
     * Saves a secure string under a key in the iOS Keychain.
     * Overwrites/updates the entry if it already exists.
     */
    @objc
    public func saveSecureString(_ key: String, value: String) -> Bool {
        guard let data = value.data(using: .utf8) else { return false }
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]
        
        let attributes: [String: Any] = [
            kSecValueData as String: data,
            kSecAttrAccessible as String: kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly
        ]
        
        // Attempt to create the Keychain item
        var status = SecItemAdd(query.merging(attributes) { (_, new) in new } as CFDictionary, nil)
        
        // If the entry already exists, update it instead
        if status == errSecDuplicateItem {
            status = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)
        }
        
        return status == errSecSuccess
    }

    /**
     * Retrieves a secure string from the iOS Keychain.
     */
    @objc
    public func getSecureString(_ key: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        if status == errSecSuccess, let data = dataTypeRef as? Data {
            return String(data: data, encoding: .utf8)
        }
        
        return nil
    }

    /**
     * Deletes a secure string from the iOS Keychain.
     */
    @objc
    public func deleteSecureString(_ key: String) -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        return status == errSecSuccess || status == errSecItemNotFound
    }
}
