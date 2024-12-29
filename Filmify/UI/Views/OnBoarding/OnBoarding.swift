//
//  OnBoarding.swift
//  Filmify
//
//  Created by Rafael Loggiodice on 8/12/24.
//

import SwiftUI
import Vortex

struct OnBoarding: View {
    
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @State private var onboardingVM: OnboardingViewModel
    @State private var startAnimating: Bool = false
    @State private var startVortex: VortexProxy?
    @Environment(AppStateImpl.self) private var appState
    @Environment(AuthViewModelImpl.self) private var authViewModel
    
    private let createSignInView: any CreateSignInView
    
    init(onboardingVM: OnboardingViewModel, createSignInView: any CreateSignInView) {
        self.onboardingVM = onboardingVM
        self.createSignInView = createSignInView
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 5) {
            if onboardingVM.goToSignIn {
                createSignInView.create()
            } else {
                ZStack {
                    VortexViewReader { proxy in
                        Color.clear
                            .onAppear {
                                startVortex = proxy
                            }
                        VortexView(.confetti) {
                            Rectangle()
                                .fill(.white)
                                .frame(width: 16, height: 16)
                                .tag("square")
                            
                            Circle()
                                .fill(.white)
                                .frame(width: 16)
                                .tag("circle")
                        }
                    }
                    
                    VStack {
                        ForEach(Array(onboardingVM.welcoming.enumerated()), id: \.offset) { lineIndex, line in
                            HStack(spacing: 2) {
                                ForEach(Array(line.enumerated()), id: \.offset) { charIndex, char in
                                    characterView(char: String(char), lineIndex: lineIndex, charIndex: charIndex, isBold: onboardingVM.isBoldCharacter(line: line, charIndex: charIndex))
                                }
                            }
                        }
                        startButton
                    }
                }
            }
        }
        .onAppear {
            startAnimating.toggle()
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.2) {
                withAnimation {
                    onboardingVM.showButton = true
                    startVortex?.burst()
                }
            }
        }
    }
    
    func characterView(char: String, lineIndex: Int, charIndex: Int, isBold: Bool) -> some View {
        Text(char)
            .font(.title)
            .fontWeight(isBold ? .bold : .regular)
            .multilineTextAlignment(.center)
            .opacity(startAnimating ? 1 : 0)
            .animation(
                .easeIn(duration: 0.5)
                .delay(Double(lineIndex) * 1.7 + Double(charIndex) * 0.15),
                value: startAnimating
            )
    }
}

#Preview {
    
    @Previewable @State var authViewModel = AuthViewModelImpl(
        biometricAuthentication: BiometricAuthenticationImpl(),
        authManager: AuthManagerImpl(userBuilder: UserBuilderImpl()),
        keychain: KeychainManagerImpl.shared,
        createSession: CreateSessionUseCaseImpl(repository: CreateSessionServiceImpl(networkService: NetworkServiceImpl.shared)))
    
    OnBoarding(onboardingVM: OnboardingViewModelImpl(), createSignInView: SignInFactory())
        .environment(AppStateImpl())
        .environment(authViewModel)
}

extension OnBoarding {
    
    var startButton: some View {
        Button {
            withAnimation {
                hasCompletedOnboarding = true
                onboardingVM.goToSignIn.toggle()
            }
        } label: {
            HStack {
                Text("Get started")
                Image(systemName: "chevron.right")
            }
        }
        .controlSize(.large)
        .buttonBorderShape(.capsule)
        .buttonStyle(.borderedProminent)
        .opacity(onboardingVM.showButton ? 1 : 0)
        .padding(.top, 30)
        .preferredColorScheme(.dark)
    }
}
