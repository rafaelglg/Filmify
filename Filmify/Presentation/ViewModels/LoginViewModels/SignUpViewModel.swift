//
//  SignUpViewModel.swift
//  Filmify
//
//  Created by Rafael Loggiodice on 14/12/24.
//

import Foundation

protocol SignUpViewModel {
    var emailText: String { get set }
    var passwordText: String { get set }
        
    var emailTextValid: Bool { get set }
    var passwordTextValid: Bool { get set }
    
    var passwordSuggestion: String { get set }
    
    func verifyUserEmail(email: String)
    func validatePassword(password: String)
}

@Observable
final class SignUpViewModelImpl: SignUpViewModel {
    var goToPasswordView: Bool = false
    var emailText: String = ""
    var passwordText: String = ""
    var emailTextValid: Bool = false
    var passwordTextValid: Bool = false
    var passwordSuggestion: String = """
            The password must meet the following requirements:
            - The password must not contain blank spaces.
            - At least 8 characters
            - At least one capital letter
            - At least one lowercase letter
            - At least one number
            - At least one special character (!@#$%^&*(),.?":{}|<>)
            """
    
    func verifyUserEmail(email: String) {
        
        if email.isEmpty {
            emailTextValid = false
        }
        
        let emailRegex = "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        if !emailPredicate.evaluate(with: email) {
            emailTextValid = false
            return
        }
        
        let components = email.split(separator: "@")
        guard components.count == 2, let domain = components.last else {
            emailTextValid = false
            return
        }
        
        let insecureDomains = ["spam.com", "example.com"]
        if insecureDomains.contains(String(domain)) {
            emailTextValid = false
            return
        }
        emailTextValid = true
    }
    
    func validatePassword(password: String) {
        
        // Al menos 8 caracteres
        let minLengthPredicate = NSPredicate(format: "SELF MATCHES %@", "^.{8,}$")
        
        // Al menos una letra mayúscula
        let uppercasePredicate = NSPredicate(format: "SELF MATCHES %@", ".*[A-Z].*")
        
        // Al menos una letra minúscula
        let lowercasePredicate = NSPredicate(format: "SELF MATCHES %@", ".*[a-z].*")
        
        // Al menos un número
        let numberPredicate = NSPredicate(format: "SELF MATCHES %@", ".*[0-9].*")
        
        // Al menos un carácter especial
        let specialCharacterPredicate = NSPredicate(format: "SELF MATCHES %@", ".*[!@#$%^&*(),.?\":{}|<>].*")
        
        let predicates = [
            minLengthPredicate,
            uppercasePredicate,
            lowercasePredicate,
            numberPredicate,
            specialCharacterPredicate
        ]
        
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        
        // Verificar si la contraseña contiene espacios
        guard !password.contains(" ") else {
            passwordTextValid = false
            return
        }
        
        guard !password.isEmpty else {
            passwordTextValid = false
            return
        }
        
        // Evaluar la contraseña con el compoundPredicate
        guard compoundPredicate.evaluate(with: password) else {
            passwordTextValid = false
            return
        }
        
        passwordTextValid = true
    }
}
