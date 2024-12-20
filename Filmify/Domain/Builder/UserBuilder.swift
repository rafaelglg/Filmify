//
//  UserBuilder.swift
//  Filmify
//
//  Created by Rafael Loggiodice on 18/12/24.
//

import Foundation

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
