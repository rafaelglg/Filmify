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
    var personDetail: PersonDetailModel = .preview
    var isLoading: Bool = false

    var cancellable = Set<AnyCancellable>()
    
    init(castMemberUseCase: MovieCastMemberUsesCase = MoviecasMemberUsesCaseImpl()) {
        self.castMemberUseCase = castMemberUseCase
    }
    
    func getCastMembers(id: String) {
        isLoading = true
        
        do {
            try castMemberUseCase.executeCastMembers(from: .id(id))
                .receive(on: DispatchQueue.main)
                .sink { [weak self] completion in
                    guard let self else { return }
                    defer {
                        isLoading = false
                    }
                    switch completion {
                    case .finished: break
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
    
    func getPersonDetailInfo(id: String) {
        isLoading = true
        do {
            try castMemberUseCase.executePersonDetail(from: .id(id))
                .receive(on: DispatchQueue.main)
                .sink { [weak self] completion in
                    guard let self else { return }
                    
                    defer {
                        isLoading = false
                    }
                    
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        print(error)
                        print(error.localizedDescription)
                    }
                } receiveValue: { [weak self] person in
                    self?.personDetail = person
                    print(person)
                }.store(in: &cancellable)

        } catch {
            
        }
    }
}
