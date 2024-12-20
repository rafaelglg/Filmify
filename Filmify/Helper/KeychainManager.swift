//
//  KeychainManager.swift
//  Filmify
//
//  Created by Rafael Loggiodice on 18/12/24.
//

import Foundation

final class KeychainManagerImpl {
    
    static func save(email: String, password: String) throws {
        
        let query: [String: AnyObject] = [
            
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: email as AnyObject,
            kSecValueData as String: password.data(using: .utf8) as AnyObject
        ]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        
        guard status != errSecDuplicateItem else {
            throw KeychainError.duplicateEntry
        }
        
        guard status == errSecSuccess else {
            throw KeychainError.unknown(status)
        }
    }
    
    static func get(email: String) throws(KeychainError) -> String? {
        
        let query: [String: AnyObject] = [
            
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: email as AnyObject,
            kSecReturnData as String: kCFBooleanTrue,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var password: String?
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        guard status != errSecInvalidKeychain else {
            throw KeychainError.invalidKeychain
        }
        
        guard status != errSecItemNotFound else {
            throw KeychainError.itemNotFound
        }
        
        guard status == errSecSuccess else {
            throw KeychainError.unknown(status)
        }
        
        guard let data = result as? Data else {
            throw KeychainError.unknown(status)
        }
        
        password = String(data: data, encoding: .utf8)
        return password
    }
    
    static func delete(email: String) throws {
        
        let query: [String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: email as AnyObject
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw KeychainError.unknown(status)
        }
    }
    
}
