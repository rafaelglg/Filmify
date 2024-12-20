//
//  SignUpFactory.swift
//  Filmify
//
//  Created by Rafael Loggiodice on 19/12/24.
//

final class SignUpFactory: CreateSignUpView {
    
    func createSignUpView() -> SignUpView {
        SignUpView(signUpVM: createSignUpViewModel(),
                   createSignUpView: SignUpFactory())
    }
    
    private func createSignUpViewModel() -> SignUpViewModel {
        SignUpViewModelImpl()
    }
    
    func createPasswordView() -> PasswordView {
        PasswordView(signUpVM: createSignUpViewModel())
    }
}
