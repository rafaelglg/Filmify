//
//  EnterAsGuestUseCase.swift
//  Filmify
//
//  Created by Rafael Loggiodice on 22/12/24.
//

import Combine

protocol EnterAsGuestUseCase {
    func execute() -> AnyPublisher<GuestModel, Error>
}

final class EnterAsGuestUseCaseImpl: EnterAsGuestUseCase {
    
    private let repository: GuestResponseService
    
    init(repository: GuestResponseService) {
        self.repository = repository
    }
    
    func execute() -> AnyPublisher<GuestModel, Error> {
        repository.fetchGuestResponse()
    }
}
