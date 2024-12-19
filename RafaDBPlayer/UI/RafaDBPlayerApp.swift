//
//  RafaDBPlayerApp.swift
//  RafaDBPlayer
//
//  Created by Rafael Loggiodice on 6/11/24.
//

import SwiftUI

@main
struct RafaDBPlayerApp: App {
    
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    
    var body: some Scene {
        WindowGroup {
            Group {
                if !hasCompletedOnboarding {
                    AppStarterFactory.createOnboarding()
                } else {
                    AppStarterFactory.createInitialView()
                }
            }
        }
    }
}
