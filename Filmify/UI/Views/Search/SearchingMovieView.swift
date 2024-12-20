//
//  SearchingMovieView.swift
//  Filmify
//
//  Created by Rafael Loggiodice on 18/12/24.
//

import SwiftUI

struct SearchingMovieView: View {
    @Environment(MovieViewModel.self) private var movieVM
    @State private var movieReviewVM: MovieReviewViewModel
    @State private var castMemberVM: MovieCastMembersViewModel
    let columns = Array(repeating: GridItem(.flexible()), count: 3)
    @State private var selectedMovie: MovieResultResponse?
    
    let title: LocalizedStringKey
    let movie: [MovieResultResponse]
    
    init(movieReviewVM: MovieReviewViewModel, castMemberVM: MovieCastMembersViewModel, title: LocalizedStringKey, movie: [MovieResultResponse]) {
        self.movieReviewVM = movieReviewVM
        self.castMemberVM = castMemberVM
        self.title = title
        self.movie = movie
    }
    
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
    @Previewable @State var movieUsesCasesImpl = MovieUsesCasesImpl(repository: MovieProductServiceImpl(productService: NetworkService.shared))
    @Previewable @State var movieReviewViewModel = MovieReviewViewModel(movieReviewUsesCase: MovieReviewUsesCaseImpl(repository: MovieReviewServiceImpl(productService: ReviewProductServiceImpl(networkService: NetworkService.shared))))
    @Previewable @State var movieCastViewModel = MovieCastMembersViewModel(castMemberUseCase: MovieCastMemberUsesCaseImpl(repository: CastMembersServiceImpl(networkService: NetworkService.shared)))
    
    SearchingMovieView(movieReviewVM: movieReviewViewModel,
                       castMemberVM: movieCastViewModel,
                       title: "Filtered",
                       movie: [.preview])
        .environment(MovieViewModel(movieUsesCase: movieUsesCasesImpl))
}
