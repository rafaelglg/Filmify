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
    var biometricAuthentication: BiometricAuthentication { get }
    
    func signIn(email: String, password: String)
    
    func setEmail(withEmail email: String)
    func setPassword(password: String)
    func setFullName(fullName: String)
    func createUser()
}

@Observable
final class AuthViewModelImpl: AuthViewModel {
    var currentUser: UserModel?
    var userBuilder: UserBuilder?
    
    var biometricAuthentication: BiometricAuthentication
    
    init(biometricAuthentication: BiometricAuthentication = BiometricAuthenticationImpl(), userBuilder: UserBuilder = UserBuilderImpl()) {
        self.biometricAuthentication = biometricAuthentication
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
    
    func setEmail(withEmail email: String) {
        userBuilder?.setEmail(email)
    }
    
    func setPassword(password: String) {
        userBuilder?.setPassword(password)
    }
    
    func setFullName(fullName: String) {
        userBuilder?.setFullName(fullName)
    }
    
    @MainActor
    func authenticate() {
        Task {
            await biometricAuthentication.biometricAuthentication()
            if biometricAuthentication.isAuthenticated {
                
            }
        }
    }
    
    func createUser() {
        guard let user = userBuilder?.build() else {
            print("Error: Missing data to create user")
            return
        }
        self.currentUser = user
    }
    
    func signOut() {
        currentUser = nil
        userBuilder?.reset()
    }
}

protocol UserBuilder {
    var email: String? { get }
    var password: String? { get }
    var fullName: String? { get }
    
    func setEmail(_ email: String)
    func setPassword(_ password: String)
    func setFullName(_ fullName: String)
    
    func build() -> UserModel?
    func reset()
    
}

final class UserBuilderImpl: UserBuilder {
    
    var email: String?
    var password: String?
    var fullName: String?
    
    func setEmail(_ email: String) {
        self.email = email
    }
    
    func setPassword(_ password: String) {
        self.password = password
    }
    
    func setFullName(_ fullName: String) {
        self.fullName = fullName
    }
    
    func build() -> UserModel? {
        guard let email = email, let password = password, let fullName = fullName else {
            print("email: " + (email ?? ""), "password: " + (password ?? ""), "fullname: " + (fullName ?? ""))
            return nil
        }
        
        return UserModel(email: email, password: password, fullName: fullName)
    }
    
    func reset() {
        email = nil
        password = nil
        fullName = nil
    }
}
