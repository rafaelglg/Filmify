//
//  Dashboard.swift
//  Filmify
//
//  Created by Rafael Loggiodice on 6/11/24.
//

import SwiftUI

struct Dashboard: View {
    
    @Environment(MovieViewModel.self) var movieVM
    @Environment(NetworkMonitorImpl.self) var network
    private let createSectionMovie: CreateSectionMovie
    
    init(createSectionMovie: CreateSectionMovie) {
        self.createSectionMovie = createSectionMovie
    }
    
    var body: some View {
        ZStack {
                if let network = network.isConnected {
                    if !network {
                        NoInternetConnectionView()
                    } else {
                        showDashboard
                    }
                }
            if movieVM.isLoadingDetailView {
                customProgressView
            }
        }
        .scrollDismissesKeyboard(.immediately)
        .preferredColorScheme(.dark)
        .clipped()
        .onAppear {
            movieVM.getDashboard()
        }
    }
}

#Preview {
    @Previewable @State var movieUsesCasesImpl = MovieUsesCasesImpl(repository: MovieProductServiceImpl(productService: NetworkServiceImpl.shared))

    Dashboard(createSectionMovie: SectionMovieFactory())
        .environment(MovieViewModel(movieUsesCase: movieUsesCasesImpl))
        .environment(NetworkMonitorImpl())
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
    }
    
    @ViewBuilder
    var showDashboard: some View {
        @Bindable var movieVM = movieVM
        ScrollView {
            sectionMovies
                .alert("App error", isPresented: $movieVM.showingAlert) {
                    Button("Ok") {}
                } message: { Text(movieVM.alertMessage) }
        }
    }
    
    @ViewBuilder
    var sectionMovies: some View {
        if movieVM.isLoading {
            customProgressView
                .frame(height: UIScreen.main.bounds.height / 3.5)
        } else {
            createSectionMovie.createSectionView()
        }
    }
}
