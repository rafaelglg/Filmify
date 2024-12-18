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
    func mapLaError(_ error: LAError) -> BiometricAuthenticationError
    func showBiometricError(_ error: KeychainError)
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
        
        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
            
            do {
                let success = try await context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason)
                isAuthenticated = success
            } catch {
                isAuthenticated = false
                showingAlert.toggle()
                alertMessage = error.localizedDescription
            }
        } else {
            if let laError = error as? LAError {
                let errorMessage = mapLaError(laError)
                alertMessage = errorMessage.localizedDescription
            }
            isAuthenticated = false
            showingAlert.toggle()
        }
    }
    
    func mapLaError(_ error: LAError) -> BiometricAuthenticationError {
        switch error.code {
        case .biometryNotEnrolled:
            return .noBiometricEnrolled(biometricType == .faceID ? "face ID" : "touch ID")
        case .biometryNotAvailable:
            return .notAvailableBiometry(biometricType == .faceID ? "face ID" : "touch ID")
        default:
            return .uknown
        }
    }
    
    func showBiometricError(_ error: KeychainError) {
        alertMessage = error.localizedDescription
        showingAlert = true
    }
}
