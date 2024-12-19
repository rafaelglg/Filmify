//
//  SearchViewFactory.swift
//  RafaDBPlayer
//
//  Created by Rafael Loggiodice on 19/12/24.
//

import SwiftUICore

final class SearchViewFactory: CreateSearchView {
    
    private let searchingMovieFactory = SearchingMovieFactory()
    
    @MainActor func createSearchView() -> AnyView {
        return AnyView(SearchView(createSearchingMovie: searchingMovieFactory)
            .environment(EnvironmentFactory.movieVM))
    }
}

final class SearchingMovieFactory: CreateSearchingMovie {
    
    @MainActor func createSearchingMovieView(title: LocalizedStringKey,
                                             movie: [MovieResultResponse]) -> SearchingMovieView {
        return SearchingMovieView(movieReviewVM: MovieViewModelFactory.createMovieReviewViewModel(),
                                  castMemberVM: MovieViewModelFactory.createMovieCastMembersViewModel(),
                                  title: title, movie: movie)
    }
}
