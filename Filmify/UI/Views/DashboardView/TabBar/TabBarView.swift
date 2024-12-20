//
//  TabBarView.swift
//  Filmify
//
//  Created by Rafael Loggiodice on 16/12/24.
//

import SwiftUI

struct TabBarView: View {
    
    @State private var movieVM: MovieViewModel
    @State private var network: NetworkMonitorImpl
    @Environment(AuthViewModelImpl.self) private var authViewModel
    
    private let createDashboard: CreateDashboard
    private let createSearchView: CreateSearchView
    private let createProfileView: CreateProfileView
    
    init(movieVM: MovieViewModel, network: NetworkMonitorImpl, createDashboard: CreateDashboard, createSearchView: CreateSearchView, createProfileView: CreateProfileView) {
        self.movieVM = movieVM
        self.network = network
        self.createDashboard = createDashboard
        self.createSearchView = createSearchView
        self.createProfileView = createProfileView
    }
    
    var body: some View {
        TabView {
            
            Tab("Home", systemImage: "house") {
                createDashboard.createDashboardView()
            }
            
            Tab("Search", systemImage: "magnifyingglass") {
                createSearchView.createSearchView()
            }
            
            Tab("Profile", systemImage: "person.crop.circle.fill") {
                createProfileView.createProfile()
            }
        }
        .customTabBarAppearance(forUnselectedItem: .white)
    }
}

#Preview(traits: .environments) {
    @Previewable @State var movieUsesCasesImpl = MovieUsesCasesImpl(repository: MovieProductServiceImpl(productService: NetworkService.shared))

    TabBarView(movieVM: MovieViewModel(movieUsesCase: movieUsesCasesImpl),
               network: NetworkMonitorImpl(),
               createDashboard: DashboardFactory(),
               createSearchView: SearchViewFactory(),
               createProfileView: ProfileViewFactory())
        .environment(AuthViewModelImpl())
}
