//
//  SignUpView.swift
//  Filmify
//
//  Created by Rafael Loggiodice on 10/12/24.
//

import SwiftUI

struct SignUpView: View {
    
    @State private var signUpVM: SignUpViewModel
    @FocusState private var focusState: FieldState?
    
    @Environment(\.dismiss) private var dismiss
    @Environment(AppStateImpl.self) private var appState
    @Environment(AuthViewModelImpl.self) private var authViewModel
    
    private let createSignUpView: CreateSignUpView
    
    init(signUpVM: SignUpViewModel, createSignUpView: CreateSignUpView) {
        self.signUpVM = signUpVM
        self.createSignUpView = createSignUpView
    }
    
    var body: some View {
        @Bindable var appState = appState
        NavigationStack(path: $appState.navigationPath) {
            signUpView
                .toolbar {
                    ToolbarItem(placement: .navigation) {
                        closeButton
                    }
                }
                .onChange(of: signUpVM.emailText) {_, newValue in
                    signUpVM.verifyUserEmail(email: newValue)
                }
                .onAppear(perform: focusToEmail)
                .preferredColorScheme(.dark)
        }
    }
}

#Preview {
    
    @Previewable @State var authViewModel = AuthViewModelImpl(
        biometricAuthentication: BiometricAuthenticationImpl(),
        authManager: AuthManagerImpl(userBuilder: UserBuilderImpl()),
        keychain: KeychainManagerImpl.shared,
        createSession: CreateSessionUseCaseImpl(repository: CreateSessionServiceImpl(networkService: NetworkServiceImpl.shared)))
    
    SignUpView(signUpVM: SignUpViewModelImpl(authViewModel: authViewModel), createSignUpView: SignUpFactory())
        .environment(authViewModel)
        .environment(AppStateImpl())
}

extension SignUpView {
    
    var closeButton: some View {
        Button {
            appState.changeSignUpState(newValue: nil)
        } label: {
            Image(systemName: "x.circle.fill")
                .tint(.primary)
        }
    }
    
    var signUpView: some View {
        VStack {
            Spacer()
            
            yourEmailText
            
            CustomTextfield(placeholder: "jane@appleseed.com", text: $signUpVM.emailText)
                .textContentType(.emailAddress)
                .focused($focusState, equals: .email)
                .submitLabel(.continue)
                .onSubmit {
                    guard signUpVM.emailTextValid else {
                        return
                    }
                    authViewModel.authManager.setEmail(withEmail: signUpVM.emailText)
                    appState.pushTo(.fullName)
                }
            
            Spacer()
            continueButton
        }
    }
    
    var yourEmailText: some View {
        Text("What's your e-mail")
            .font(.title2)
            .bold()
    }
    
    var continueButton: some View {
        VStack {
            Button {
                authViewModel.authManager.setEmail(withEmail: signUpVM.emailText)
                appState.pushTo(.fullName)
            } label: {
                Text("Continue")
                    .bold()
                    .tint(.primary)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            .navigationDestination(for: SignUpState.self) { state in
                if state == .password {
                    createSignUpView.createPasswordView()
                } else if state == .fullName {
                    createSignUpView.createFullNameView()
                }
            }
            
            .frame(height: 50)
            .background(signUpVM.emailTextValid ? .buttonBG : .textfieldBackground, in: RoundedRectangle(cornerRadius: 15))
            .padding()
        }
        .allowsHitTesting(signUpVM.emailTextValid)
        .opacity(signUpVM.emailTextValid ? 1 : 0.5)
    }
    
    func focusToEmail() {
        focusState = .email
    }
}

/*
 HStack {
 Text("Important!")
 .frame(width: 200)
 .background(.blue)
 GeometryReader { proxy in
 Image(systemName: "applelogo")
 .resizable()
 .scaledToFit()
 .frame(width: proxy.size.width, height: proxy.size.height * 1.8)
 .background(.red)
 }
 }
 */
