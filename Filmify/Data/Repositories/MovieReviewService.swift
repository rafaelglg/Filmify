//
//  MovieReviewService.swift
//  Filmify
//
//  Created by Rafael Loggiodice on 14/11/24.
//

import Foundation
import Combine

protocol MovieReviewService {
    func fetchMovieReviews(from path: MovieEndingPath) -> AnyPublisher <MovieReviewModel, Error>
    func postMovieRating(movieID: MovieEndingPath, rating: Float) -> AnyPublisher<RatingResponseModel, Error>
}

final class MovieReviewServiceImpl: MovieReviewService {
    
    private let productService: ReviewProductService
    
    init(productService: ReviewProductService) {
        self.productService = productService
    }
    
    func fetchMovieReviews(from path: MovieEndingPath) -> AnyPublisher <MovieReviewModel, Error> {
        return productService.fetchMovieReviews(from: path)
    }
    
    func postMovieRating(movieID: MovieEndingPath, rating: Float) -> AnyPublisher<RatingResponseModel, Error> {
        productService.postRatingToMovie(movieId: movieID, ratingValue: rating)
    }
}
