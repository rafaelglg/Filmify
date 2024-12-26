//
//  FullNameView.swift
//  Filmify
//
//  Created by Rafael Loggiodice on 24/12/24.
//

import SwiftUI

struct FullNameView: View {
    
    @State private var signUpVM: SignUpViewModel
    
    @FocusState private var focusState: FieldState?
    @Environment(AppStateImpl.self) private var appState
    @Environment(AuthViewModelImpl.self) private var authViewModel
    
    init(signUpVM: SignUpViewModel) {
        self.signUpVM = signUpVM
    }
    
    var body: some View {
        fullNameView
            .onChange(of: signUpVM.fullNameText) { _, newValue in
                signUpVM.validateFullName(name: newValue)
            }
            .onAppear(perform: focusToName)
    }
}

#Preview {
    
    @Previewable @State var authViewModel = AuthViewModelImpl(
        biometricAuthentication: BiometricAuthenticationImpl(),
        authManager: AuthManagerImpl(userBuilder: UserBuilderImpl()),
        keychain: KeychainManagerImpl.shared,
        enterAsGuestUseCase: EnterAsGuestUseCaseImpl(repository: GuestResponseServiceImpl(networkService: NetworkService.shared)))
    
    FullNameView(signUpVM: SignUpViewModelImpl(authViewModel: authViewModel))
        .environment(authViewModel)
        .environment(AppStateImpl())
}

extension FullNameView {
    
    var fullNameView: some View {
        VStack {
            Spacer()
            VStack {
                fullNameTitle
                
                CustomTextfield(placeholder: "Jane Appleseed", text: $signUpVM.fullNameText)
                    .textContentType(.name)
                    
                    .focused($focusState, equals: .name)
                    .submitLabel(.go)
                    .onSubmit {
                        guard signUpVM.fullNameTextValid else {
                            return
                        }
                        authViewModel.authManager.setFullName(fullName: signUpVM.fullNameText)
                        appState.pushTo(.password)
                    }
            }
            
            Spacer()
            continueButton
        }
    }
    
    var fullNameTitle: some View {
        Text("Enter your full name")
            .font(.title2)
            .bold()
    }
    
    var continueButton: some View {
        VStack {
            Button {
                authViewModel.authManager.setFullName(fullName: signUpVM.fullNameText)
                appState.pushTo(.password)
            } label: {
                Text("Continue")
                    .bold()
                    .tint(.primary)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            .frame(height: 50)
            .background(signUpVM.fullNameTextValid ? .buttonBG : .textfieldBackground, in: RoundedRectangle(cornerRadius: 15))
            .padding()
        }
        .allowsHitTesting(signUpVM.fullNameTextValid)
        .opacity(signUpVM.fullNameTextValid ? 1 : 0.5)
    }
    
    func focusToName() {
        focusState = .name
    }
}
