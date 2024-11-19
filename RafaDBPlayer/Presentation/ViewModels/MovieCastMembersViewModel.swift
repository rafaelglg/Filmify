//
//  MovieCastMembersViewModel.swift
//  RafaDBPlayer
//
//  Created by Rafael Loggiodice on 17/11/24.
//

import Foundation
import Combine

@Observable
final class MovieCastMembersViewModel {
    let castMemberUseCase: MovieCastMemberUsesCase
    var castModel: CastModel = .preview

    var cancellable = Set<AnyCancellable>()
    
    init(castMemberUseCase: MovieCastMemberUsesCase = MoviecasMemberUsesCaseImpl()) {
        self.castMemberUseCase = castMemberUseCase
    }
    
    func getCastMembers(id: String) {
        do {
            try castMemberUseCase.execute(from: .id(id))
                .receive(on: DispatchQueue.main)
                .sink { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        print(error)
                        print(error.localizedDescription)
                    }
                } receiveValue: { [weak self] cast in
                    self?.castModel = cast
                }.store(in: &cancellable)

        } catch {
            
        }
    }
}
