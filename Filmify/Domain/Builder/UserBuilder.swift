//
//  UserBuilder.swift
//  Filmify
//
//  Created by Rafael Loggiodice on 18/12/24.
//

import Foundation
import FirebaseAuth
import FirebaseCore

protocol UserBuilder {
    var email: String { get set }
    var password: String { get set }
    var fullName: String { get set }
    
    mutating func setEmail(_ email: String)
    mutating func setPassword(_ password: String)
    mutating func setFullName(_ fullName: String)
    
    func build(user: AuthDataResult) -> UserModel?
    func reset()
}

extension UserBuilder {
    mutating func setEmail(_ email: String) {
        self.email = email
    }
    
    mutating func setPassword(_ password: String) {
        self.password = password
    }
    
    mutating func setFullName(_ fullName: String) {
        self.fullName = fullName
    }
}

final class UserBuilderImpl: UserBuilder {
    
    var email: String = ""
    var password: String = ""
    var fullName: String = ""
    
    func build(user: AuthDataResult) -> UserModel? {
        return UserModel(id: user.user.uid,
                         email: user.user.email ?? "",
                         password: password,
                         fullName: fullName,
                         createdAt: Timestamp(date: Date()))
    }
    
    func reset() {
        email = ""
        password = ""
        fullName = ""
    }
}
