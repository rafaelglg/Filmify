//
//  AppViewState.swift
//  RafaDBPlayer
//
//  Created by Rafael Loggiodice on 16/12/24.
//

enum SignUpState: Identifiable {
    case signIn
    case signUp
    case signOut
    case password
    case dashboard
    
    var id: String {
        switch self {
        case .signIn: return "signIn"
        case .signUp: return "signUp"
        case .password: return "password"
        case .dashboard: return "dashboard"
        case .signOut: return "signOut"
        }
    }
}
