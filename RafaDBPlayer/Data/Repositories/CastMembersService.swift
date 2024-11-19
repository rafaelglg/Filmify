//
//  CastMembersService.swift
//  RafaDBPlayer
//
//  Created by Rafael Loggiodice on 17/11/24.
//

import Combine

protocol CastMembersService {
    func fetchMovieCastMembers(from path: MovieEndingPath) throws -> AnyPublisher<CastModel, Error>
}

final class CastMembersServiceImpl: CastMembersService {
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol = NetworkService.shared) {
        self.networkService = networkService
    }
    
    func fetchMovieCastMembers(from path: MovieEndingPath) throws -> AnyPublisher<CastModel, Error> {
        return try networkService.fetchCastMembers(endingPath: path)
    }
}
