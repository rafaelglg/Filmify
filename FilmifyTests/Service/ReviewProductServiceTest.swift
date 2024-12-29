//
//  ReviewProductServiceTest.swift
//  Filmify
//
//  Created by Rafael Loggiodice on 7/12/24.
//

import Testing
import Foundation
import Combine
@testable import Filmify

@Suite("Review product service")
struct ReviewProductServiceTest {
    
    let sut: ReviewProductService
    var serviceMock = ReviewProductServiceMock()
    
    init(sut: ReviewProductService = ReviewProductServiceMock()) {
        self.sut = serviceMock
    }
    
    @Test("Movie review", .tags(.resultOK))
    func fetchMovieReview_ResultOK() {
        
        var cancellable = Set<AnyCancellable>()
        var movieReviewMock: MovieReviewResponse?
        
        sut.fetchMovieReviews(from: .reviews)
            .sink { completion in
                switch completion {
                    
                case .finished:
                    break
                case .failure(let error):
                    Issue.record(error, "The test should not fail")
                }
            } receiveValue: { response in
                let reviewResponse = response.results.first
                movieReviewMock = reviewResponse
                #expect(reviewResponse?.authorDetails == movieReviewMock?.authorDetails)
                #expect(reviewResponse?.content == movieReviewMock?.content)
            }
            .store(in: &cancellable)
    }
    
    @Test("Movie review result KO", .tags(.resultKO))
    func fetchMovieReview_ResultKO() {
        
        var cancellable = Set<AnyCancellable>()
        serviceMock.shouldReturnError = true
        
        sut.fetchMovieReviews(from: .reviews)
            .sink { completion in
                switch completion {
                    
                case .finished:
                    break
                case .failure(let error):
                    #expect(error as? ErrorManager == .badURL)
                }
            } receiveValue: { _ in
                Issue.record("The test should not fail")
            }
            .store(in: &cancellable)

    }
}

final class ReviewProductServiceMock: ReviewProductService {
    
    var shouldReturnError: Bool = false
    let movieReviewMock = MovieReviewModel(page: 1, results: [.preview])
    var ratingModelMock = RatingResponseModel(success: true, statusCode: 1, statusMessage: "")
    
    func fetchMovieReviews(from path: MovieEndingPath) -> AnyPublisher<MovieReviewModel, Error> {
        if shouldReturnError {
            return Fail(error: ErrorManager.badURL).eraseToAnyPublisher()
        } else {
            return Just(movieReviewMock)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
    }
    
    func postRatingToMovie(movieId: MovieEndingPath, ratingValue: Float) -> AnyPublisher<RatingResponseModel, Error> {
        if shouldReturnError {
            return Fail(error: ErrorManager.badURL).eraseToAnyPublisher()
        } else {
            return Just(ratingModelMock)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
    }
}
