//
//  SearchingMovieView.swift
//  RafaDBPlayer
//
//  Created by Rafael Loggiodice on 18/12/24.
//

import SwiftUI

struct SearchingMovieView: View {
    @Environment(MovieViewModel.self) private var movieVM
    @State private var movieReviewVM = MovieReviewViewModel()
    @State private var castMemberVM = MovieCastMembersViewModel()
    let columns = Array(repeating: GridItem(.flexible()), count: 3)
    @State private var selectedMovie: MovieResultResponse?
    
    let title: LocalizedStringKey
    let movie: [MovieResultResponse]
    
    var body: some View {
        @Bindable var movieVM = movieVM
        VStack(alignment: .leading) {
            Text(title)
                .font(.title3)
                .fontWeight(.bold)
            
            LazyVGrid(columns: columns, alignment: .center, spacing: 15) {
                ForEach(movie, id: \.id) { movie in
                    MovieCell(movie: movie, imageURL: movie.posterURLImage)
                        .onTapGesture {
                            selectedMovie = movie
                            movieVM.getMovieDetails(id: movie.id.description)
                        }
                }
            }
        }
        .sheet(item: $selectedMovie) { movie in
            MediaDetailView(movie: movie, movieReviewVM: movieReviewVM, castMembersVM: $castMemberVM)
        }
        .presentationCornerRadius(15)
        .scrollIndicators(.hidden)
        .padding(.leading)
        .padding(.top)
    }
}

#Preview {
    SearchingMovieView(title: "Filtered", movie: [.preview])
        .environment(MovieViewModel())
}
