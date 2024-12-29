//
//  SignInViewModel.swift
//  Filmify
//
//  Created by Rafael Loggiodice on 13/12/24.
//

import Foundation
import Combine

protocol SignInViewModel {
    var emailText: String { get set }
    var passwordText: String { get set }    
}

@Observable
final class SignInViewModelImpl: SignInViewModel {
    var emailText: String = ""
    var passwordText: String = ""
}
