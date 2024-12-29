//
//  SearchView.swift
//  Filmify
//
//  Created by Rafael Loggiodice on 18/12/24.
//

import SwiftUI

struct SearchView: View {
    
    @Environment(MovieViewModel.self) private var movieVM
    
    private let createSearchingMovie: CreateSearchingMovie
    
    init(createSearchingMovie: CreateSearchingMovie) {
        self.createSearchingMovie = createSearchingMovie
    }
    
    var body: some View {
        @Bindable var movieVM = movieVM
        NavigationStack {
            ScrollView {
                searchView
            }
            .searchable(text: $movieVM.searchText.value, prompt: "Look for a movie")
        }
    }
}

#Preview {
    @Previewable @State var movieUsesCasesImpl = MovieUsesCasesImpl(repository: MovieProductServiceImpl(productService: NetworkServiceImpl.shared))

    SearchView(createSearchingMovie: SearchingMovieFactory())
        .environment(MovieViewModel(movieUsesCase: movieUsesCasesImpl))
}

extension SearchView {
    
    var searchView: some View {
        LazyVStack {
            if movieVM.isSearching {
                filteredMovies
            } else {
                Text("You can search movies, by using their names, years of creation...")
                    .frame(height: 500)
                    .padding()
            }
        }
    }
    
    @ViewBuilder
    var filteredMovies: some View {
        if movieVM.filteredMovies.isEmpty && movieVM.noSearchResult {
            ContentUnavailableView("No movies found", systemImage: "binoculars.circle.fill", description: Text("No found for the movie ''\(movieVM.searchText.value)''"))
        } else {
            createSearchingMovie.createSearchingMovieView(title: "Filtered Movies", movie: movieVM.filteredMovies)
        }
    }
}
