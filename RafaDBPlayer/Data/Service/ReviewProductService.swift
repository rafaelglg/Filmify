//
//  ReviewProductService.swift
//  RafaDBPlayer
//
//  Created by Rafael Loggiodice on 14/11/24.
//

import Foundation
import Combine

protocol ReviewProductService {
    func fetchMovieReviews(from path: MovieEndingPath) -> AnyPublisher <MovieReviewModel, Error>
}

final class ReviewProductServiceImpl: ReviewProductService {
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol = NetworkService.shared) {
        self.networkService = networkService
    }
    
    func fetchMovieReviews(from path: MovieEndingPath) -> AnyPublisher <MovieReviewModel, Error> {
        return networkService.fetchMovieReviews(endingPath: path)
    }
}
