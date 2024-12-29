//
//  CreateSessionUseCase.swift
//  Filmify
//
//  Created by Rafael Loggiodice on 26/12/24.
//

import Combine

protocol CreateSessionUseCase {
    func executeSignInAsGuest() -> AnyPublisher<GuestModel, Error>
}

final class CreateSessionUseCaseImpl: CreateSessionUseCase {
    private let repository: CreateSessionService
    
    init(repository: CreateSessionService) {
        self.repository = repository
    }
    
    func executeSignInAsGuest() -> AnyPublisher<GuestModel, Error> {
        repository.fetchGuestResponse()
    }
}
