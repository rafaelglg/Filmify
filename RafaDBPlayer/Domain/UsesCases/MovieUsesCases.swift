//
//  MovieUsesCases.swift
//  RafaDBPlayer
//
//  Created by Rafael Loggiodice on 15/11/24.
//

import Combine

protocol MovieUsesCases {
    func executeNowPlayingMovies() -> AnyPublisher<MovieModel, Error>
    func executeTopRatedMovies() -> AnyPublisher<MovieModel, Error>
    func executeUpcomingMovies() -> AnyPublisher<MovieModel, Error>
    func executeTrendingMovies(timePeriod: MovieEndingPath) -> AnyPublisher<MovieModel, Error>
    func executeDetailMovies(id: String) -> AnyPublisher<MovieDetails, Error>
    func executeSearch(query: String) -> AnyPublisher<MovieModel, Error>
}

final class MovieUsesCasesImpl: MovieUsesCases {
    
    private let repository: MovieProductService
    typealias PublisherResult = AnyPublisher<MovieModel, Error>
    
    init(repository: MovieProductService) {
        self.repository = repository
    }
    
    func executeNowPlayingMovies() -> PublisherResult {
        return repository.fetchMoviesProducts(basePath: Constants.movieGeneralPath, endingPath: .nowPlaying)
    }
    
    func executeTopRatedMovies() -> PublisherResult {
        return repository.fetchMoviesProducts(basePath: Constants.movieGeneralPath, endingPath: .topRated)
    }
    
    func executeUpcomingMovies() -> PublisherResult {
        return repository.fetchMoviesProducts(basePath: Constants.movieGeneralPath, endingPath: .upcoming)
    }
    
    func executeTrendingMovies(timePeriod: MovieEndingPath) -> PublisherResult {
        return repository.fetchMoviesProducts(basePath: Constants.trendingMovies, endingPath: timePeriod)
    }
    
    func executeDetailMovies(id: String) -> AnyPublisher<MovieDetails, Error> {
        return repository.fetchDetailMovie(id: .id(id), endingPath: [.videos])
    }
    
    func executeSearch(query: String) -> AnyPublisher<MovieModel, Error> {
        return repository.fetchSearchMovies(query: query)
    }
}
