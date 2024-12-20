//
//  KeychainError.swift
//  Filmify
//
//  Created by Rafael Loggiodice on 18/12/24.
//

import Foundation

enum KeychainError: Error, LocalizedError {
    case duplicateEntry
    case invalidKeychain
    case unknown(OSStatus)
    case itemNotFound
    
    var errorDescription: String? {
        switch self {
        case .duplicateEntry:
            return "They key is duplicated, try to use another one"
        case .invalidKeychain:
            return "Keychain invalid"
        case .unknown(let oSStatus):
            return "uknown error \(oSStatus.description)"
        case .itemNotFound:
            return "You need to sign in first to access biometric authentication."
        }
    }
}
