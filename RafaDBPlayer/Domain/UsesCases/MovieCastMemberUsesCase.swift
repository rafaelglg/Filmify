//
//  MovieCastMemberUsesCase.swift
//  RafaDBPlayer
//
//  Created by Rafael Loggiodice on 17/11/24.
//

import Combine

protocol MovieCastMemberUsesCase {
    func execute(from path: MovieEndingPath) throws -> AnyPublisher<CastModel, Error>
}

final class MoviecasMemberUsesCaseImpl: MovieCastMemberUsesCase {
    private let repository: CastMembersService
    
    init(repository: CastMembersService = CastMembersServiceImpl()) {
        self.repository = repository
    }
    
    func execute(from path: MovieEndingPath) throws -> AnyPublisher<CastModel, Error> {
        return try repository.fetchMovieCastMembers(from: path)
    }
}
