//
//  MovieReviewService.swift
//  RafaDBPlayer
//
//  Created by Rafael Loggiodice on 14/11/24.
//

import Foundation
import Combine

protocol MovieReviewService {
    func fetchMovieReviews(from path: MovieEndingPath) throws -> AnyPublisher <MovieReviewModel, Error>
}

final class MovieReviewServiceImpl: MovieReviewService {
    
    private let productService: ReviewProductService
    
    init(productService: ReviewProductService = ReviewProductService()) {
        self.productService = productService
    }
    
    func fetchMovieReviews(from path: MovieEndingPath) throws -> AnyPublisher <MovieReviewModel, Error> {
        return try productService.fetchMovieReviews(from: path)
    }
}
