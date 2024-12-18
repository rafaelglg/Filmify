//
//  Authentication.swift
//  RafaDBPlayer
//
//  Created by Rafael Loggiodice on 13/12/24.
//

import LocalAuthentication

protocol BiometricAuthentication {
    
    var biometricType: LABiometryType { get }
    var isAuthenticated: Bool { get }
    var showingAlert: Bool { get set }
    var alertMessage: String { get }
    var isAuthenticating: Bool { get }
    
    func getBiometricType()
    func mapLaError(_ error: LAError) -> AuthenticationError
    @MainActor
    func biometricAuthentication() async
}

@Observable
final class BiometricAuthenticationImpl: BiometricAuthentication {
    
    var biometricType: LABiometryType = .none
    var isAuthenticated: Bool = false
    var showingAlert: Bool = false
    var alertMessage: String = ""
    var isAuthenticating: Bool = false
    
    func getBiometricType() {
        let context = LAContext()
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) {
             biometricType = context.biometryType
        }
    }
    
    @MainActor
    func biometricAuthentication() async {
        let context = LAContext()
        var error: NSError?
        let reason = "We need to verify your identity"
        
        isAuthenticating = true
        
        defer {
            isAuthenticating = false
        }
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            
            do {
                let success = try await context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason)
                isAuthenticated = success
            } catch {
                showingAlert.toggle()
                alertMessage = error.localizedDescription
            }
        } else {
            if let laError = error as? LAError {
                let errorMessage = mapLaError(laError)
                alertMessage = errorMessage.localizedDescription
            }
            showingAlert.toggle()
        }
    }
    
    func mapLaError(_ error: LAError) -> AuthenticationError {
        switch error.code {
        case .biometryNotEnrolled:
            return .noBiometricEnrolled(biometricType == .faceID ? "face ID" : "touch ID")
        case .biometryNotAvailable:
            return .notAvailableBiometry(biometricType == .faceID ? "face ID" : "touch ID")
        default:
            return .uknown
        }
    }
}

enum AuthenticationError: Error, LocalizedError {
    case noBiometricEnrolled(String)
    case notAvailableBiometry(String)
    case uknown
    
    var errorDescription: String? {
        switch self {
        case .noBiometricEnrolled(let device):
            return "You have denied access. Please go to your settings app and turn on the \(device) authentication."
        case .uknown:
            return "Uknown error"
        case .notAvailableBiometry(let device):
            return "Authentication could not start because \(device) is not available on the device."
        }
    }
}
