//
//  MovieReviewViewModel.swift
//  RafaDBPlayer
//
//  Created by Rafael Loggiodice on 11/11/24.
//

import Foundation
import Combine

@Observable
final class MovieReviewViewModel {
    let networkManager: any NetworkManagerProtocol
    var cancellable = Set<AnyCancellable>()
    var movieReviews = [MovieReviewResponse]()
    var htmlConvertedTexts: [String: String] = [:]
    
    var alertMessage: String = ""
    
    init(networkManager: any NetworkManagerProtocol = NetworkManager.shared) {
        self.networkManager = networkManager
    }
    
    func getMovieReviews(id: String) {
        do {
            try networkManager.fetchMovieReviews(endingPath: .id(id))
                .eraseToAnyPublisher()
                .receive(on: DispatchQueue.main)
                .map(\.results)
                .sink { [weak self] completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        print(error)
                        print(error.localizedDescription)
                        self?.alertMessage = error.localizedDescription
                    }
                } receiveValue: { [weak self] movieReview in
                    self?.movieReviews = movieReview
                    dump(movieReview)
                }
                .store(in: &cancellable)

        } catch {
            print(error)
            print("entra por el catch")
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
}
