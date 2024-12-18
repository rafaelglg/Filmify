//
//  MediaSectionView.swift
//  RafaDBPlayer
//
//  Created by Rafael Loggiodice on 7/11/24.
//

import SwiftUI

struct MediaSectionView: View {
    
    @Environment(MovieViewModel.self) private var movieVM
    @State private var movieReviewVM = MovieReviewViewModel()
    @State private var castMemberVM = MovieCastMembersViewModel()
    
    @State private var cachedMovies: [MovieResultResponse] = []
    @State private var isRendered: Bool = false
    
    let title: LocalizedStringKey
    let movie: [MovieResultResponse]
    
    var body: some View {
        @Bindable var movieVM = movieVM
        
        VStack(alignment: .leading) {
            movieTitle
            
            MovieListView(movies: cachedMovies) { selectedMovie in
                movieVM.selectedMovie = selectedMovie
                movieVM.getMovieDetails(id: selectedMovie.id.description)
            }
            .sheet(item: $movieVM.selectedMovie) { movie in
                MediaDetailView(movie: movie, movieReviewVM: movieReviewVM, castMembersVM: $castMemberVM)
            }
            .presentationCornerRadius(15)
            .scrollIndicators(.hidden)
        }
        .onAppear { // using this to avoid re render every time going to search bar and coming back
            if cachedMovies.isEmpty {
                cachedMovies = movie
            }
        }
        .onChange(of: movie) { _, new in
            cachedMovies = new // Update cache movies with all movies from api
        }
        .padding(.leading)
        .padding(.top)
    }
}

#Preview {
    MediaSectionView(title: "Movies", movie: [.preview])
        .environment(MovieViewModel())
}
extension MediaSectionView {
    var movieTitle: some View {
        Text(title)
            .font(.title3)
            .fontWeight(.bold)
    }
}
