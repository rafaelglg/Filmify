//
//  KeychainManager.swift
//  Filmify
//
//  Created by Rafael Loggiodice on 18/12/24.
//

import Foundation

protocol KeychainManager {
    
    func save(uid: String, email: String, password: String) throws(KeychainError)
    func getEmail(userID: String) throws(KeychainError) -> String
    func getPassword(email: String) throws(KeychainError) -> String?
    func delete(email: String) throws
    func clearKeychain() throws
}

final class KeychainManagerImpl: KeychainManager, Sendable {
    
    static let shared = KeychainManagerImpl()
    
    private init() {}
    
    func save(uid: String, email: String, password: String) throws(KeychainError) {
        
        // Save email
        let queryEmail: [String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: uid as AnyObject, // Usamos UID como clave
            kSecValueData as String: email.data(using: .utf8) as AnyObject
        ]
        
        // Save password
        let queryPassword: [String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: email as AnyObject, // Usamos el email como clave
            kSecValueData as String: password.data(using: .utf8) as AnyObject
        ]
        
        // Add email to keychain
        var result: CFTypeRef?
        let statusEmail = SecItemAdd(queryEmail as CFDictionary, &result)
        
        guard statusEmail != errSecDuplicateItem else {
            throw KeychainError.duplicateEntry
        }
        guard statusEmail == errSecSuccess else {
            throw KeychainError.unknown(statusEmail)
        }
        
        // Add password to keychain
        let statusPassword = SecItemAdd(queryPassword as CFDictionary, &result)
        guard statusPassword != errSecDuplicateItem else {
            throw KeychainError.duplicateEntry
        }
        guard statusPassword == errSecSuccess else {
            throw KeychainError.unknown(statusPassword)
        }
    }
    
    func getEmail(userID: String) throws(KeychainError) -> String {
        
        let query: [String: AnyObject] = [
            
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: userID as AnyObject,
            kSecReturnData as String: kCFBooleanTrue,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var result: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        guard status != errSecItemNotFound else {
            throw KeychainError.itemNotFound
        }
        
        guard status == errSecSuccess else {
            throw KeychainError.unknown(status)
        }
        
        guard let data = result as? Data else {
            throw KeychainError.unknown(status)
        }
        
        guard let email = String(data: data, encoding: .utf8) else {
            throw .decodeDataError
        }
        return email
    }
    
    func getPassword(email: String) throws(KeychainError) -> String? {
        
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
            return nil
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
    
    func updatePassword(email: String, newPassword: String) throws {
        let query: [String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: email as AnyObject
        ]
        
        let attributesToUpdate: [String: AnyObject] = [
            kSecValueData as String: newPassword.data(using: .utf8)! as AnyObject
        ]
        
        let status = SecItemUpdate(query as CFDictionary, attributesToUpdate as CFDictionary)
        guard status == errSecSuccess else {
            throw KeychainError.unknown(status)
        }
    }

    func delete(email: String) throws {
        
        let query: [String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: email as AnyObject
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw KeychainError.unknown(status)
        }
    }
    
    func clearKeychain() throws {
        let query: [String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw KeychainError.unknown(status)
        }
    }
}
