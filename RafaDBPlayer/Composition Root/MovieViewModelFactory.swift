//
//  MovieViewModelFactory.swift
//  RafaDBPlayer
//
//  Created by Rafael Loggiodice on 19/12/24.
//

final class MovieViewModelFactory {
    
    static func createMovieReviewViewModel() -> MovieReviewViewModel {
        MovieReviewViewModel(movieReviewUsesCase: createMovieReviewUsesCase())
    }
    
    static private func createMovieReviewUsesCase() -> MovieReviewUsesCase {
        MovieReviewUsesCaseImpl(repository: createMovieReviewRepository())
    }
    
    static private func createMovieReviewRepository() -> MovieReviewService {
        MovieReviewServiceImpl(productService: createMovieReviewService())
    }
    
    static private func createMovieReviewService() -> ReviewProductService {
        ReviewProductServiceImpl(networkService: createMovieReviewNetwork())
    }
    
    static private func createMovieReviewNetwork() -> NetworkServiceProtocol {
        NetworkService.shared
    }
    
    static func createMovieCastMembersViewModel() -> MovieCastMembersViewModel {
        MovieCastMembersViewModel(castMemberUseCase: createMovieCastMembersUsesCase())
    }
    
    static private func createMovieCastMembersUsesCase() -> MovieCastMemberUsesCase {
        MovieCastMemberUsesCaseImpl(repository: createMovieCastMembersRepository())
    }
    
    static private func createMovieCastMembersRepository() -> CastMembersService {
        CastMembersServiceImpl(networkService: createMovieCastNetwork())
    }
    
    static private func createMovieCastNetwork() -> NetworkServiceProtocol {
        NetworkService.shared
    }
}
