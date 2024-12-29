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
    var sessionId: String { get set }
    var isAdmin: Bool { get set }
    
    mutating func setEmail(_ email: String)
    mutating func setPassword(_ password: String)
    mutating func setFullName(_ fullName: String)
    mutating func setSessionId(_ sessionId: String)
    mutating func setUserAsAdmin(_ newValue: Bool)

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
    
    mutating func setSessionId(_ sessionId: String) {
        self.sessionId = sessionId
    }
    
    mutating func setUserAsAdmin(_ newValue: Bool) {
        self.isAdmin = newValue
    }
}

final class UserBuilderImpl: UserBuilder {
    
    var email: String = ""
    var password: String = ""
    var fullName: String = ""
    var sessionId: String = ""
    var isAdmin: Bool = false
    
    func build(user: AuthDataResult) -> UserModel? {
        return UserModel(id: user.user.uid,
                         email: user.user.email ?? "",
                         password: password,
                         fullName: fullName,
                         sessionId: sessionId,
                         createdAt: Timestamp(date: Date()),
                         isAdmin: isAdmin)
    }
    
    func reset() {
        email = ""
        password = ""
        fullName = ""
    }
}
