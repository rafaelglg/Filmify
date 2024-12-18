//
//  AuthViewModel.swift
//  RafaDBPlayer
//
//  Created by Rafael Loggiodice on 17/12/24.
//

import Foundation

protocol AuthViewModel {
    var currentUser: UserModel? { get }
    var userBuilder: UserBuilder? { get }
    
    func signIn(email: String, password: String)
    func createUser()
}

protocol BiometricAuthenticationType {
    var biometricAuth: BiometricAuthentication { get }
    @MainActor
    func biometricAuthentication(email: String)
}

protocol KeychainAuth {
    func getkeyFromKeychain()
    func saveToKeychain(email: String, password: String)
    func deleteFromKeychain(email: String)
}

protocol AuthViewModelBuilder {
    func setEmail(withEmail email: String)
    func setPassword(password: String)
    func setFullName(fullName: String)
}

@Observable
final class AuthViewModelImpl: AuthViewModel {
    var currentUser: UserModel?
    var userBuilder: UserBuilder?
    
    var biometricAuth: BiometricAuthentication
    var biometricErrorMessage: String = ""
    
    init(biometricAuthentication: BiometricAuthentication = BiometricAuthenticationImpl(),
         userBuilder: UserBuilder = UserBuilderImpl()) {
        self.biometricAuth = biometricAuthentication
        self.userBuilder = userBuilder
    }
    
    func signIn(email: String, password: String) {
        guard !email.isEmpty, !password.isEmpty else {
            print("falta info como nombre password o contraseña")
            return
        }
        let emailLowercased = email.lowercased()
        
        currentUser = UserModel(email: emailLowercased, password: password, fullName: userBuilder?.email ?? "")
    }
    
    func createUser() {
        guard let user = userBuilder?.build() else {
            print("Error: Missing data to create user")
            return
        }
        self.currentUser = user
        
        saveToKeychain(email: user.email, password: user.password)
    }
    
    func signOut() {
        currentUser = nil
        userBuilder?.reset()
    }
}

extension AuthViewModelImpl: AuthViewModelBuilder {
    // MARK: Builder methods
    func setEmail(withEmail email: String) {
        userBuilder?.setEmail(email)
    }
    
    func setPassword(password: String) {
        userBuilder?.setPassword(password)
    }
    
    func setFullName(fullName: String) {
        userBuilder?.setFullName(fullName)
    }
}

extension AuthViewModelImpl: BiometricAuthenticationType {
    // MARK: Biometric auth methods
    @MainActor
    func biometricAuthentication(email: String) {
        Task {
            await biometricAuth.biometricAuthentication()
            if biometricAuth.isAuthenticated {
                do throws(KeychainError) {
                     _ = try KeychainManagerImpl.get(email: email)
                } catch {
                    biometricAuth.showBiometricError(error)
                    print(error)
                    print("error no hay credentials guardados")
                }
                
            }
        }
    }
}

extension AuthViewModelImpl: KeychainAuth {
    // MARK: keychain methods
    
    func getkeyFromKeychain() {
        do {
            _ = try KeychainManagerImpl.get(email: currentUser?.email ?? "")
        } catch {
            print(error)
            print("error")
        }
    }
    
    func saveToKeychain(email: String, password: String) {
        do {
            try KeychainManagerImpl.save(email: email, password: password)
        } catch {
            print(error)
            print("error")
        }
    }
    
    func deleteFromKeychain(email: String) {
        do {
            try KeychainManagerImpl.delete(email: email)
        } catch {
            print(error)
            print("error")
        }
    }
}
