//
//  MovieReviewViewModel.swift
//  RafaDBPlayer
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

@Observable
final class MovieReviewViewModel {
    private let movieReviewUsesCase: MovieReviewUsesCase
    var cancellable = Set<AnyCancellable>()
    var movieReviews = [MovieReviewResponse]()
    var htmlConvertedTexts: [String: String] = [:]
    
    var alertMessage: String = ""
    var isLoading: Bool = false
    
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
    
    init(movieReviewUsesCase: MovieReviewUsesCase = MovieReviewUsesCaseImpl()) {
        self.movieReviewUsesCase = movieReviewUsesCase
    }
    
    func getReviews(id: String) {
        isLoading = true
        do {
            try movieReviewUsesCase.execute(from: .id(id))
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
                    }
                } receiveValue: { [weak self] movieReview in
                    self?.movieReviews = movieReview
                    print(movieReview)
                }
                .store(in: &cancellable)

        } catch {
            self.alertMessage = error.localizedDescription
        }
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
    
    private func sortReviews() {
        switch currentSortOptions {
        case .lowToHight:
            movieReviews.sort {$0.authorDetails.rating ?? 0 < $1.authorDetails.rating ?? 0}
        case .highToLow:
            movieReviews.sort {$0.authorDetails.rating ?? 0 > $1.authorDetails.rating ?? 0}
        case .none:
            break
        }
    }
    
    private func sortByDate() {
        switch currentDateSort {
        case .newestFirst:
            movieReviews.sort {$0.creationDate > $1.creationDate}
        case .oldestFirst:
            movieReviews.sort {$0.creationDate < $1.creationDate}
        case .none:
            break
        }
    }
}
