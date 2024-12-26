//
//  AppViewState.swift
//  Filmify
//
//  Created by Rafael Loggiodice on 16/12/24.
//

enum SignUpState: Identifiable {
    case signIn
    case signUp
    case signOut
    case password
    case fullName
    
    var id: String {
        switch self {
        case .signIn: return "signIn"
        case .signUp: return "signUp"
        case .password: return "password"
        case .fullName: return "fullName"
        case .signOut: return "signOut"
        }
    }
}
