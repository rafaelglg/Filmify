//
//  Dashboard.swift
//  RafaDBPlayer
//
//  Created by Rafael Loggiodice on 6/11/24.
//

import SwiftUI

struct Dashboard: View {
    
    @Environment(MovieViewModel.self) var movieVM
    
    var body: some View {
        @Bindable var movieVM = movieVM
        NavigationStack {
            ZStack {
                ScrollView {
                    LazyVStack {
                        if movieVM.isSearching {
                            filteredMovies
                        } else {
                            SectionMovies()
                        }
                    }
                    
                    .searchable(text: $movieVM.searchText.value, prompt: "Look for a movie")
                    
                    .sheet(isPresented: $movieVM.showProfile) {
                        RafaView()
                    }
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
                    .preferredColorScheme(.dark)
                }
                .scrollDismissesKeyboard(.immediately)
                progressView
            }
            .onAppear { movieVM.getDashboard() }
        }
    }
}

#Preview {
    Dashboard()
        .environment(MovieViewModel())
}

extension Dashboard {
    
    @ViewBuilder
    // This progress view appears when clicking in a movie from dashboard
    var progressView: some View {
        if movieVM.isLoading {
            Color.black.opacity(0.7)
                .ignoresSafeArea()
            
            VStack {
                ProgressView()
                    .frame(width: 80, height: 80)
                    .cornerRadius(8)
                    .padding(.bottom, 10)
                
                Text("Please wait...")
                    .font(.callout)
                    .foregroundColor(.white)
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
