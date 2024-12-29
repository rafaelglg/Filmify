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
    
    @MainActor private func createSignUpViewModel() -> SignUpViewModel {
        SignUpViewModelImpl(authViewModel: EnvironmentFactory.authViewModel)
    }
    
    func createPasswordView() -> PasswordView {
        PasswordView(signUpVM: createSignUpViewModel())
    }
    
    func createFullNameView() -> FullNameView {
        FullNameView(signUpVM: createSignUpViewModel())
    }
}
