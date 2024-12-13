//
//  SignInView.swift
//  RafaDBPlayer
//
//  Created by Rafael Loggiodice on 10/12/24.
//

import SwiftUI
import LocalAuthentication

struct SignInView: View {
    
    @Environment(MovieViewModel.self) var movieVM
    @Environment(NetworkMonitorImpl.self) var network
    @State private var authentication: BiometricAuthentication = BiometricAuthenticationImpl()
    @State private var signInVM: SignInViewModel  = SignInViewModelImpl()
    @FocusState private var focusFieldEmail: FieldState?
    @FocusState private var focusFieldPassword: FieldState?
    
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()
                .onTapGesture {
                    focusFieldEmail = nil
                    focusFieldPassword = nil
                }
            
            VStack {
                if authentication.isAuthenticated {
                    Dashboard()
                        .environment(movieVM)
                        .environment(network)
                } else {
                    loginView
                }
            }
            .preferredColorScheme(.dark)
            .alert(isPresented: $authentication.showingAlert) {
                Alert(title: Text("Authentication failed"),
                      message: Text(authentication.alertMessage),
                      dismissButton: .cancel())
            }
        }
    }
}

#Preview(traits: .environments) {
    SignInView()
}

extension SignInView {
    
    var loginView: some View {
        VStack {
            Text("Sign in")
                .font(.title)
                .bold()
                .frame(height: 90)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
            
            CustomTextfield(placeholder: "Email", text: $signInVM.emailText, focusField: _focusFieldEmail)
                .focused($focusFieldEmail, equals: .email)
            
            CustomSecureField(placeholder: "Password", passwordText: $signInVM.passwordText, focusField: _focusFieldPassword)
                .focused($focusFieldPassword, equals: .password)
            
            signInButton
            biometricButton
            authenticationButtons
        }
    }
    
    var signInButton: some View {
        Button {
            
        } label: {
            Text("Sign in")
                .tint(.primary)
                .frame(maxWidth: .infinity, alignment: .center)
        }
        .frame(height: 50)
        .background(.buttonBG, in: RoundedRectangle(cornerRadius: 15))
        .padding()
    }
    
    @ViewBuilder
    var biometricButton: some View {
        let biometryType = authentication.biometricType
        Button {
            Task {
                await authentication.biometricAuthentication()
            }
        } label: {
            Image(systemName: biometryType == .faceID ? "faceid" : "touchid" )
                .resizable()
                .tint(.primary)
                .scaledToFit()
                .frame(width: 50)
                .symbolEffect(.variableColor.iterative, isActive: authentication.isAuthenticating)
                .symbolEffect(.bounce, value: authentication.isAuthenticated)
        }
        .padding(.vertical, 30)
    }
    
    var authenticationButtons: some View {
        VStack {
            Text("or login with")
            HStack {
                Button {
                } label: {
                    Image(systemName: "applelogo" )
                        .resizable()
                        .tint(.primary)
                        .scaledToFit()
                        .frame(width: 20)
                }
                Button {
                } label: {
                    Image(systemName: "applelogo" )
                        .resizable()
                        .tint(.primary)
                        .scaledToFit()
                        .frame(width: 20)
                }
            }
            .padding(.top, 10)
        }
    }
}
