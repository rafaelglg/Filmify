//
//  GuestResponseService.swift
//  Filmify
//
//  Created by Rafael Loggiodice on 22/12/24.
//

import Combine

protocol GuestResponseService {
    func fetchGuestResponse() -> AnyPublisher<GuestModel, Error>
}

final class GuestResponseServiceImpl: GuestResponseService {
    
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    func fetchGuestResponse() -> AnyPublisher<GuestModel, Error> {
        return networkService.fetchGuestResponse()
    }
}
