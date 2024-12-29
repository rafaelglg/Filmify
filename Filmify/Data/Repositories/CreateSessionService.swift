//
//  CreateSessionMovieService.swift
//  Filmify
//
//  Created by Rafael Loggiodice on 26/12/24.
//

import Combine

protocol CreateSessionService {
    func fetchGuestResponse() -> AnyPublisher<GuestModel, Error>
}

final class CreateSessionServiceImpl: CreateSessionService {
    private let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func fetchGuestResponse() -> AnyPublisher<GuestModel, Error> {
        return networkService.fetchGuestResponse()
    }
}
