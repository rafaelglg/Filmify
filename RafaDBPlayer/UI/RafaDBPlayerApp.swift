//
//  RafaDBPlayerApp.swift
//  RafaDBPlayer
//
//  Created by Rafael Loggiodice on 6/11/24.
//

import SwiftUI

@main
struct RafaDBPlayerApp: App {
    
    let authViewModel = AuthViewModelImpl()
    let appState = AppStateImpl()
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    
    var body: some Scene {
        WindowGroup {
            Group {
                if !hasCompletedOnboarding {
                    OnBoarding()
                        .environment(authViewModel)
                        .environment(appState)
                } else if authViewModel.currentUser == nil {
                    SignInView()
                        .environment(appState)
                        .environment(authViewModel)
                } else {
                    TabBarView()
                        .environment(authViewModel)
                        .transition(.blurReplace())
                }
            }
        }
    }
}
