//
//  PasswordView.swift
//  Filmify
//
//  Created by Rafael Loggiodice on 14/12/24.
//

import SwiftUI

struct PasswordView: View {
    
    @State private var signUpVM: SignUpViewModel
    
    @FocusState private var focusState: FieldState?
    @Environment(AppStateImpl.self) private var appState
    @Environment(AuthViewModelImpl.self) private var authViewModel
    
    init(signUpVM: SignUpViewModel) {
        self.signUpVM = signUpVM
    }
    
    var body: some View {
        passwordView
            .onChange(of: signUpVM.passwordText) { _, newValue in
                signUpVM.validatePassword(password: newValue)
            }
            .onAppear(perform: focusToPassword)
    }
}

#Preview {
    PasswordView(signUpVM: SignUpViewModelImpl())
        .environment(AuthViewModelImpl())
        .environment(AppStateImpl())
}

extension PasswordView {
    
    var passwordView: some View {
        VStack {
            Spacer()
            VStack {
                setPasswordText
                
                CustomSecureField(placeholder: "min. 8 char", passwordText: $signUpVM.passwordText)
                    .textContentType(.newPassword)
                    .focused($focusState, equals: .password)
                    .submitLabel(.go)
                    .onSubmit {
                        guard signUpVM.passwordTextValid else {
                            return
                        }
                        authViewModel.setPassword(password: signUpVM.passwordText)
                        authViewModel.setFullName(fullName: "Rafael Lo")
                        authViewModel.createUser()
                        appState.popToRoot()
                    }
                
                errorMessage
            }
            
            Spacer()
            continueButton
        }
    }
    
    var setPasswordText: some View {
        Text("Set a password")
            .font(.title2)
            .bold()
    }
    
    var errorMessage: some View {
        Text(signUpVM.passwordSuggestion)
            .foregroundStyle(.primary)
            .font(.subheadline)
            .padding(.horizontal)
    }
    
    var continueButton: some View {
        VStack {
            Button {
                appState.popToRoot()
                authViewModel.setPassword(password: signUpVM.passwordText)
                authViewModel.setFullName(fullName: "Rafael Lo")
                authViewModel.createUser()
            } label: {
                Text("Continue")
                    .bold()
                    .tint(.primary)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            .frame(height: 50)
            .background(signUpVM.passwordTextValid ? .buttonBG : .textfieldBackground, in: RoundedRectangle(cornerRadius: 15))
            .padding()
        }
        .allowsHitTesting(signUpVM.passwordTextValid)
        .opacity(signUpVM.passwordTextValid ? 1 : 0.5)
    }
    
    func focusToPassword() {
        focusState = .password
    }
}
