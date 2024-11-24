//
//  MovieCastMemberUsesCase.swift
//  RafaDBPlayer
//
//  Created by Rafael Loggiodice on 17/11/24.
//

import Combine

protocol MovieCastMemberUsesCase {
    func executeCastMembers(from path: MovieEndingPath) throws -> AnyPublisher<CastModel, Error>
    func executePersonDetail(from path: MovieEndingPath) throws -> AnyPublisher<PersonDetailModel, Error>
}

final class MoviecasMemberUsesCaseImpl: MovieCastMemberUsesCase {
    private let repository: CastMembersService
    
    init(repository: CastMembersService = CastMembersServiceImpl()) {
        self.repository = repository
    }
    
    func executeCastMembers(from path: MovieEndingPath) throws -> AnyPublisher<CastModel, Error> {
        return try repository.fetchMovieCastMembers(from: path)
    }
    
    func executePersonDetail(from path: MovieEndingPath) throws -> AnyPublisher<PersonDetailModel, Error> {
        return try repository.fetchPersonDetailInfo(from: path)
    }
}
