//
//  CreateSessionUseCase.swift
//  Filmify
//
//  Created by Rafael Loggiodice on 26/12/24.
//

import Combine

protocol CreateSessionUseCase {
    func executeCreateToken() -> AnyPublisher<TokenResponseModel, Error>
    func executeSignInAsGuest() -> AnyPublisher<GuestModel, Error>
    func executeSessionID(token: String) -> AnyPublisher<SessionIdResponseModel, Error>
    func executeDeleteSessionID(sessionId: String) -> AnyPublisher<DeleteSessionIdResponseModel, Error>
}

final class CreateSessionUseCaseImpl: CreateSessionUseCase {
    private let repository: CreateSessionService
    
    init(repository: CreateSessionService) {
        self.repository = repository
    }
    
    func executeCreateToken() -> AnyPublisher<TokenResponseModel, Error> {
        repository.fetchToken()
    }
    
    func executeSignInAsGuest() -> AnyPublisher<GuestModel, Error> {
        repository.fetchGuestResponse()
    }
    
    func executeSessionID(token: String) -> AnyPublisher<SessionIdResponseModel, Error> {
        repository.createSessionID(token: token)
    }
    
    func executeDeleteSessionID(sessionId: String) -> AnyPublisher<DeleteSessionIdResponseModel, any Error> {
        repository.deleteSessionID(sessionId: sessionId)
    }
}
