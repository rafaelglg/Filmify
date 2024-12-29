//
//  SignInView.swift
//  Filmify
//
//  Created by Rafael Loggiodice on 10/12/24.
//

import SwiftUI

struct SignInView: View {
    
    @FocusState private var focusField: FieldState?
    
    @State private var signInVM: SignInViewModel
    @Environment(AuthViewModelImpl.self) private var authViewModel
    @Environment(AppStateImpl.self) private var appState
    
    private let createSignUpView: CreateSignUpView
    
    init(signInVM: SignInViewModel, createSignUpView: CreateSignUpView) {
        self.signInVM = signInVM
        self.createSignUpView = createSignUpView
    }
    
    var body: some View {
        ZStack {
            dismissKeyboardTapInBackground
            VStack {
                loginView
            }
            .animation(.smooth, value: authViewModel.biometricAuth.isAuthenticated)
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
    
    SignInView(signInVM: SignInViewModelImpl(),
               createSignUpView: SignUpFactory())
        .environment(authViewModel)
        .environment(AppStateImpl())
}

extension SignInView {
    
    var dismissKeyboardTapInBackground: some View {
        // To dismiss the keyboard when tap the background
        Color(.systemBackground)
            .ignoresSafeArea()
            .onTapGesture {
                focusField = nil
            }
    }
    
    var loginView: some View {
        VStack {
            Spacer()
            Text("Sign in")
                .font(.title)
                .bold()
                .frame(height: 90)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
            
            CustomTextfield(placeholder: "Email", text: $signInVM.emailText)
                .focused($focusField, equals: .email)
                .submitLabel(.next)
                .onSubmit {
                    focusField = .password
                }
            
            CustomSecureField(placeholder: "Password", passwordText: $signInVM.passwordText)
                .focused($focusField, equals: .password)
                .submitLabel(.done)
                .onSubmit {
                    withAnimation {
                        authViewModel.signIn(email: signInVM.emailText, password: signInVM.passwordText)
                    }
                }
            
            signInButton
            guestButton
            biometricButton
            authenticationButtons
            Spacer()
            registerButton
        }
    }
    
    var guestButton: some View {
        Button {
            withAnimation {
                authViewModel.signInAsGuest()
            }
        } label: {
            
            if authViewModel.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, alignment: .center)
            } else {
                Text("Enter as a guest")
                    .tint(.primary)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
        }
        .frame(height: 50)
        .background(.indigo, in: RoundedRectangle(cornerRadius: 15))
        .padding()
    }
    
    @ViewBuilder
    var signInButton: some View {
        @Bindable var authViewModel = authViewModel
        Button {
            withAnimation {
                authViewModel.signIn(email: signInVM.emailText, password: signInVM.passwordText)
            }
        } label: {
            if authViewModel.isLoadingSignInSession {
                ProgressView()
                    .frame(maxWidth: .infinity, alignment: .center)
            } else {
                Text("Sign in")
                    .frame(maxWidth: .infinity, alignment: .center)
                    .tint(.primary)
            }
        }
        .frame(height: 50)
        .background(.buttonBG, in: RoundedRectangle(cornerRadius: 15))
        .padding()
        .alert("Successful", isPresented: $authViewModel.authManager.showAlert) {
            Button("Bye") {}
        } message: {
            Text(authViewModel.authManager.didDeleteUserMessage)
        }
    }
    
    @ViewBuilder
    var biometricButton: some View {
        @Bindable var authViewModel = authViewModel
        let authentication = authViewModel.biometricAuth
        Button {
            authViewModel.biometricAuthentication()
        } label: {
            Image(systemName: authentication.biometricType == .touchID ? "touchid" : "faceid" )
                .resizable()
                .tint(.primary)
                .scaledToFit()
                .symbolEffect(.variableColor.iterative, isActive: authentication.isAuthenticating)
                .symbolEffect(.bounce, value: authentication.isAuthenticated)
        }
        .frame(height: 50)
        .padding(.vertical, 30)
        .alert(isPresented: $authViewModel.biometricAuth.showingAlert) {
            Alert(title: Text("Authentication failed"),
                  message: Text(authViewModel.biometricAuth.alertMessage),
                  dismissButton: .cancel())
        }
    }
    
    var authenticationButtons: some View {
        VStack {
            Text("or login with")
            Button {
                // add login to use google button
            } label: {
                Image(.movieDBLogo)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 180, height: 50)
                    .padding(.horizontal)
            }
            .background(.logoMovieDB, in: RoundedRectangle(cornerRadius: 15))
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(Color.white.opacity(0.6), lineWidth: 1))
            .buttonStyle(.borderless)
            .padding(.top, 10)
        }
    }
    
    @ViewBuilder
    var registerButton: some View {
        @Bindable var authViewModel = authViewModel
        @Bindable var appState = appState
        HStack {
            Text("New to RafaDB?")
                .font(.headline)
                .foregroundStyle(Color(.systemGray))
            Button {
                appState.changeSignUpState(newValue: .signUp)
            } label: {
                Text("Sign Up")
                    .font(.headline)
            }
            .tint(.buttonBG)
            .buttonStyle(.borderedProminent)
            .buttonBorderShape(.capsule)
        }
        .alert("Authentication failed", isPresented: $authViewModel.showErrorAlert) {
            Button("Try again") {}
        } message: {
            Text(authViewModel.authErrorMessage)
        }
        .sheet(item: $appState.currentState) {
            appState.resetNavigationPath()
        } content: { state in
            if state == .signUp {
                createSignUpView.createSignUpView()
            }
        }
    }
}
