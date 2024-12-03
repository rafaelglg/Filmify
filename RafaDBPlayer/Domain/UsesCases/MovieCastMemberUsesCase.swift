//
//  MovieCastMemberUsesCase.swift
//  RafaDBPlayer
//
//  Created by Rafael Loggiodice on 17/11/24.
//

import Combine

protocol MovieCastMemberUsesCase {
    func executeCastMembers(from path: MovieEndingPath) -> AnyPublisher<CastModel, Error>
    func executePersonDetail(from path: MovieEndingPath) -> AnyPublisher<PersonDetailModel, Error>
}

final class MoviecasMemberUsesCaseImpl: MovieCastMemberUsesCase {
    private let repository: CastMembersService
    
    init(repository: CastMembersService = CastMembersServiceImpl()) {
        self.repository = repository
    }
    
    func executeCastMembers(from path: MovieEndingPath) -> AnyPublisher<CastModel, Error> {
        return repository.fetchMovieCastMembers(from: path)
    }
    
    func executePersonDetail(from path: MovieEndingPath) -> AnyPublisher<PersonDetailModel, Error> {
        return repository.fetchPersonDetailInfo(from: path)
    }
}
