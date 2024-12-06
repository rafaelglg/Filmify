//
//  Dashboard.swift
//  RafaDBPlayer
//
//  Created by Rafael Loggiodice on 6/11/24.
//

import SwiftUI

struct Dashboard: View {
    
    @Environment(MovieViewModel.self) var movieVM
    @Environment(NetworkMonitor.self) var network
    @State private var screenSize: CGSize = .zero
    
    var body: some View {
        NavigationStack {
            ZStack {
                GeometryReader { proxy in
                    let size = proxy.size
                    EmptyView()
                        .onChange(of: size) {_, newSize in
                            screenSize = newSize
                        }

                    if let network = network.isConnected {
                        if !network {
                            NoInternetConnectionView()
                        } else {
                            scrollViewContent
                        }
                    } else {
                        customProgressView
                    }
                }
                .preferredColorScheme(.dark)
                .scrollDismissesKeyboard(.immediately)
                if movieVM.isLoadingDetailView {
                    customProgressView
                }
            }
            .onAppear { movieVM.getDashboard() }
        }
    }
}

#Preview {
    Dashboard()
        .environment(MovieViewModel())
        .environment(NetworkMonitor())
}

extension Dashboard {
    
    @ViewBuilder
    // This progress view appears when clicking in a movie from dashboard
    var customProgressView: some View {
        Color.black.opacity(0.7)
            .ignoresSafeArea()
        
        VStack {
            ProgressView()
                .frame(width: 80, height: 50)
                .cornerRadius(8)
            
            Text("Please wait...")
                .font(.callout)
                .foregroundColor(.white)
        }
        .position(x: screenSize.width / 2, y: screenSize.height / 2)
    }
    
    @ViewBuilder
    var scrollViewContent: some View {
        @Bindable var movieVM = movieVM
        ScrollView {
            showDashboard
                .alert("App error", isPresented: $movieVM.showingAlert) {
                    Button("Ok") {}
                } message: { Text(movieVM.alertMessage) }
            
                .searchable(text: $movieVM.searchText.value, prompt: "Look for a movie")
                .sheet(isPresented: $movieVM.showProfile) { RafaView() }
            
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            movieVM.showProfile.toggle()
                        } label: {
                            Text("Rafa")
                                .font(.callout)
                                .fontWeight(.bold)
                                .foregroundStyle(Color(.label))
                        }
                    }
                }
        }
    }
    
    var showDashboard: some View {
        LazyVStack {
            if movieVM.isSearching {
                filteredMovies
            } else {
                ZStack {
                    if movieVM.isLoading {
                        customProgressView
                            .frame(height: 100, alignment: .center)
                    } else {
                        SectionMovies()
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    var filteredMovies: some View {
        if movieVM.filteredMovies.isEmpty && movieVM.noSearchResult {
            ContentUnavailableView("No movies found", systemImage: "binoculars.circle.fill", description: Text("No found for the movie ''\(movieVM.searchText.value)''"))
        } else {
            SearchingMovieView(title: "Filtered Movies", movie: movieVM.filteredMovies)
        }
    }
}
