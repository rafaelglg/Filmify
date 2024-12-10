//
//  RafaDBPlayerApp.swift
//  RafaDBPlayer
//
//  Created by Rafael Loggiodice on 6/11/24.
//

import SwiftUI

@main
struct RafaDBPlayerApp: App {
    let movieVM = MovieViewModel()
    let networkMonitor = NetworkMonitorImpl()
    var body: some Scene {
        WindowGroup {
            OnBoarding()
                .environment(movieVM)
                .environment(networkMonitor)
        }
    }
}
