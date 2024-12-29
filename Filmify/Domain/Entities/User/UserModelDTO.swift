//
//  UserModelDTO.swift
//  Filmify
//
//  Created by Rafael Loggiodice on 26/12/24.
//

import Foundation
import FirebaseCore

struct UserModelDTO: Codable, Identifiable {
    let id: String
    let email: String
    var fullName: String
    let sessionId: String?
    var createdAt = Timestamp()
    let isAdmin: Bool
}

extension UserModelDTO {
    func toUserModel() -> UserModel {
        UserModel(
            id: id,
            email: email,
            password: "",
            fullName: fullName,
            sessionId: sessionId,
            createdAt: createdAt,
            isAdmin: isAdmin
        )
    }
}
