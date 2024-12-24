//
//  MovieViewModelFactory.swift
//  Filmify
//
//  Created by Rafael Loggiodice on 19/12/24.
//

@MainActor
final class MovieViewModelFactory {
    
    private init() {}
    
    private static var sharedMovieReviewViewModel: MovieReviewViewModel?
    private static var sharedMovieCastMembersViewModel: MovieCastMembersViewModel?
    
    static func createMovieReviewViewModel() -> MovieReviewViewModel {
        if let existingInstance = sharedMovieReviewViewModel {
            return existingInstance
        } else {
            let newInstance = MovieReviewViewModelImpl(movieReviewUsesCase: createMovieReviewUsesCase())
            sharedMovieReviewViewModel = newInstance
            return newInstance
        }
    }
    
    static func createMovieCastMembersViewModel() -> MovieCastMembersViewModel {
        if let existingInstance = sharedMovieCastMembersViewModel {
            return existingInstance
        } else {
            let newInstance = MovieCastMembersViewModel(castMemberUseCase: createMovieCastMembersUsesCase())
            sharedMovieCastMembersViewModel = newInstance
            return newInstance
        }
    }
    
    private static func createMovieReviewUsesCase() -> MovieReviewUsesCase {
        MovieReviewUsesCaseImpl(repository: createMovieReviewRepository())
    }
    
    private static func createMovieReviewRepository() -> MovieReviewService {
        MovieReviewServiceImpl(productService: createMovieReviewService())
    }
    
    private static func createMovieReviewService() -> ReviewProductService {
        ReviewProductServiceImpl(networkService: createMovieReviewNetwork())
    }
    
    private static func createMovieReviewNetwork() -> NetworkServiceProtocol {
        NetworkService.shared
    }
    
    private static func createMovieCastMembersUsesCase() -> MovieCastMemberUsesCase {
        MovieCastMemberUsesCaseImpl(repository: createMovieCastMembersRepository())
    }
    
    private static func createMovieCastMembersRepository() -> CastMembersService {
        CastMembersServiceImpl(networkService: createMovieCastNetwork())
    }
    
    private static func createMovieCastNetwork() -> NetworkServiceProtocol {
        NetworkService.shared
    }
}
