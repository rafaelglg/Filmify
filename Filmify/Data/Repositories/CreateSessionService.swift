//
//  CreateSessionMovieService.swift
//  Filmify
//
//  Created by Rafael Loggiodice on 26/12/24.
//

import Combine

protocol CreateSessionService {
    func fetchToken() -> AnyPublisher<TokenResponseModel, Error>
    func fetchGuestResponse() -> AnyPublisher<GuestModel, Error>
    func createSessionID(token: String) -> AnyPublisher<SessionIdResponseModel, Error>
    func deleteSessionID(sessionId: String) -> AnyPublisher<DeleteSessionIdResponseModel, Error>
}

final class CreateSessionServiceImpl: CreateSessionService {
    private let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func fetchToken() -> AnyPublisher<TokenResponseModel, Error> {
        return networkService.createToken()
    }
    
    func fetchGuestResponse() -> AnyPublisher<GuestModel, Error> {
        return networkService.fetchGuestResponse()
    }
    
    func createSessionID(token: String) -> AnyPublisher<SessionIdResponseModel, Error> {
        networkService.createSessionID(token: token)
    }
    
    func deleteSessionID(sessionId: String) -> AnyPublisher<DeleteSessionIdResponseModel, Error> {
        networkService.deleteSessionID(sessionId: sessionId)
    }
}
