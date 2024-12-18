//
//  BiometricAuthenticationError.swift
//  RafaDBPlayer
//
//  Created by Rafael Loggiodice on 18/12/24.
//

import Foundation

enum BiometricAuthenticationError: Error, LocalizedError {
    case noBiometricEnrolled(String)
    case notAvailableBiometry(String)
    case uknown
    case credentialNotSaved
    
    var errorDescription: String? {
        switch self {
        case .noBiometricEnrolled(let device):
            return "You have denied access. Please go to your settings app and turn on the \(device) authentication."
        case .uknown:
            return "Uknown error"
        case .notAvailableBiometry(let device):
            return "Authentication could not start because \(device) is not available on the device."
        case .credentialNotSaved:
            return "You need to sign in first to have face id access."
        }
    }
}
