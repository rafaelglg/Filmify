//
//  Filmify.swift
//  Filmify
//
//  Created by Rafael Loggiodice on 6/11/24.
//

import SwiftUI
import FirebaseCore

final class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

@main
struct RafaDBPlayerApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    
    var body: some Scene {
        WindowGroup {
            AppStarterFactory.startApp(hasCompletedOnboarding: hasCompletedOnboarding)
        }
    }
}
