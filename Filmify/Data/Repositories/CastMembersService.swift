//
//  CastMembersService.swift
//  Filmify
//
//  Created by Rafael Loggiodice on 17/11/24.
//

import Combine

protocol CastMembersService {
    func fetchMovieCastMembers(from path: MovieEndingPath) -> AnyPublisher<CastModel, Error>
    func fetchPersonDetailInfo(from path: MovieEndingPath) -> AnyPublisher <PersonDetailModel, Error>
}

final class CastMembersServiceImpl: CastMembersService {
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    func fetchMovieCastMembers(from path: MovieEndingPath) -> AnyPublisher<CastModel, Error> {
        return networkService.fetchCastMembers(baseURL: Constants.movieGeneralPath, id: path, endingPath: .castMembers)
    }
    
    func fetchPersonDetailInfo(from path: MovieEndingPath) -> AnyPublisher <PersonDetailModel, Error> {
        return networkService.fetchCastMembers(baseURL: Constants.personDetail, id: path, endingPath: .none )
    }
}
