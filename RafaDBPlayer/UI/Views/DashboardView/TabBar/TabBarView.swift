//
//  TabBarView.swift
//  RafaDBPlayer
//
//  Created by Rafael Loggiodice on 16/12/24.
//

import SwiftUI

struct TabBarView: View {
    
    @State private var movieVM = MovieViewModel()
    @State private var network = NetworkMonitorImpl()
    @Environment(AuthViewModelImpl.self) private var authViewModel
    
    var body: some View {
        TabView {
            
            Tab("Home", systemImage: "house") {
                Dashboard()
                    .environment(network)
                    .environment(movieVM)
            }
            
            Tab("Search", systemImage: "magnifyingglass") {
                SearchView()
                    .environment(movieVM)
            }
            
            Tab("Profile", systemImage: "person.crop.circle.fill") {
                ProfileView()
                    .environment(authViewModel)
            }
        }
    }
}

#Preview(traits: .environments) {
    TabBarView()
        .environment(AuthViewModelImpl())
}
