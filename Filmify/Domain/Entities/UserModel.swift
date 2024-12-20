//
//  UserModel.swift
//  Filmify
//
//  Created by Rafael Loggiodice on 15/12/24.
//

import Foundation

struct UserModel: Codable, Identifiable, Sendable {
    let id = UUID()
    let email: String
    let password: String
    let fullName: String
    
    var initials: String {
        let formatter = PersonNameComponentsFormatter()
        if let personComponent = formatter.personNameComponents(from: fullName) {
            formatter.style = .abbreviated
            return formatter.string(from: personComponent)
        }
        return ""
    }
    
    enum CodingKeys: CodingKey {
        case id
        case email, password, fullName
    }
}
