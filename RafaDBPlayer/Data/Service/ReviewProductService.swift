//
//  ReviewProductService.swift
//  RafaDBPlayer
//
//  Created by Rafael Loggiodice on 14/11/24.
//

import Foundation
import Combine

final class ReviewProductService {
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol = NetworkService.shared) {
        self.networkService = networkService
    }
    
    func fetchMovieReviews(from path: MovieEndingPath) throws -> AnyPublisher <MovieReviewModel, Error> {
        return try networkService.fetchMovieReviews(endingPath: path)
    }
}
