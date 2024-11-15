//
//  MovieReviewUsesCase.swift
//  RafaDBPlayer
//
//  Created by Rafael Loggiodice on 14/11/24.
//

import Combine

protocol MovieReviewUsesCase {
    func execute(from path: MovieEndingPath) throws -> AnyPublisher<MovieReviewModel, Error>
}

final class MovieReviewUsesCaseImpl: MovieReviewUsesCase {
    
    private let repository: MovieReviewService
    
    init(repository: MovieReviewService = MovieReviewServiceImpl() ) {
        self.repository = repository
    }
    
    func execute(from path: MovieEndingPath) throws -> AnyPublisher<MovieReviewModel, Error> {
        return try repository.fetchMovieReviews(from: path)
    }
}
