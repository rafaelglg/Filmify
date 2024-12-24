//
//  MovieReviewViewModel.swift
//  Filmify
//
//  Created by Rafael Loggiodice on 11/11/24.
//

import Foundation
import Combine

enum RatingSortOption {
    case lowToHight
    case highToLow
    case none
}

enum DateSortOption {
    case newestFirst
    case oldestFirst
    case none
}

protocol MovieReviewViewModel {
    var movieReviewUsesCase: MovieReviewUsesCase { get }
    var movieReviews: [MovieReviewResponse] { get }
    var htmlConvertedTexts: [String: String] { get }
    var alertMessage: String { get }
    var isLoading: Bool { get }
    var showAlert: Bool { get }
    var isLoadingRating: Bool { get }
    var showRatingPopover: Bool { get set }
    var movieRatedStatus: [String: Bool] { get }
    var ratingValue: Float { get set }
    var currentSortOptions: RatingSortOption { get set }
    var currentDateSort: DateSortOption { get set }
    
    func getReviews(id: String)
    func postRatingMovie(movieId: String, rating: Float)
    func sortReviews()
    func sortByDate()
    func onDisappear()
    func publisherHtml2Text(text: String) -> AnyPublisher<String, Never>
    func sinkHTML2String(for reviewID: String, text: String)
    func isMovieRated(movieId: String) -> Bool
}

@Observable
final class MovieReviewViewModelImpl: MovieReviewViewModel {
    let movieReviewUsesCase: MovieReviewUsesCase
    var cancellable = Set<AnyCancellable>()
    var movieReviews = [MovieReviewResponse]()
    var htmlConvertedTexts: [String: String] = [:]
    
    var alertMessage: String = ""
    var isLoading: Bool = false
    var showAlert: Bool = false
    var isLoadingRating: Bool = false
    var showRatingPopover: Bool = false
    var movieRatedStatus: [String: Bool] = [:]
    var ratingValue: Float = 0.0
    
    var currentSortOptions: RatingSortOption = .none {
        didSet {
            sortReviews()
        }
    }
    var currentDateSort: DateSortOption = .none {
        didSet {
            sortByDate()
        }
    }
    
    init(movieReviewUsesCase: MovieReviewUsesCase) {
        self.movieReviewUsesCase = movieReviewUsesCase
    }
    
    func getReviews(id: String) {
        isLoading = true
        
        movieReviewUsesCase.execute(from: .id(id))
            .receive(on: DispatchQueue.main)
            .map(\.results)
            .sink { [weak self] completion in
                
                defer {
                    self?.isLoading = false
                }
                
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self?.alertMessage = error.localizedDescription
                    self?.showAlert = true
                }
            } receiveValue: { [weak self] movieReview in
                self?.movieReviews = movieReview
            }
            .store(in: &cancellable)
    }
    
    func postRatingMovie(movieId: String, rating: Float) {
        isLoadingRating = true
        movieReviewUsesCase.executeRating(movieId: movieId, rating: rating)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                
                defer {
                    self.isLoadingRating = false
                }
                
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.alertMessage = error.localizedDescription
                    self.showAlert = true
                    self.movieRatedStatus[movieId] = false
                }
            } receiveValue: { [weak self] _ in
                self?.movieRatedStatus[movieId] = true
            }.store(in: &cancellable)
    }
    
    func isMovieRated(movieId: String) -> Bool {
        movieRatedStatus[movieId] ?? false
    }
    
    func publisherHtml2Text(text: String) -> AnyPublisher<String, Never> {
        Just(text.html2String)
            .eraseToAnyPublisher()
    }
    
    func sinkHTML2String(for reviewID: String, text: String) {
        
        publisherHtml2Text(text: text)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] text in
                self?.htmlConvertedTexts[reviewID] = text
            }
            .store(in: &cancellable)
    }
    
    func sortReviews() {
        switch currentSortOptions {
        case .lowToHight:
            movieReviews.sort {$0.authorDetails.rating ?? 0 < $1.authorDetails.rating ?? 0}
        case .highToLow:
            movieReviews.sort {$0.authorDetails.rating ?? 0 > $1.authorDetails.rating ?? 0}
        case .none:
            break
        }
    }
    
    func sortByDate() {
        switch currentDateSort {
        case .newestFirst:
            movieReviews.sort {$0.creationDate > $1.creationDate}
        case .oldestFirst:
            movieReviews.sort {$0.creationDate < $1.creationDate}
        case .none:
            break
        }
    }
    
    func onDisappear() {
        movieReviews = []
        htmlConvertedTexts = [:]
    }
}
