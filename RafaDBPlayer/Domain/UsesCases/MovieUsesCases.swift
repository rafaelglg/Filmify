//
//  MovieUsesCases.swift
//  RafaDBPlayer
//
//  Created by Rafael Loggiodice on 15/11/24.
//

import Combine

protocol MovieUsesCases {
    func executeNowPlayingMovies() throws -> AnyPublisher<MovieModel, Error>
    func executeTopRatedMovies() throws -> AnyPublisher<MovieModel, Error>
    func executeUpcomingMovies() throws -> AnyPublisher<MovieModel, Error>
    func executeTrendingMovies(timePeriod: MovieEndingPath) throws -> AnyPublisher<MovieModel, Error>
    func executeDetailMovies(id: String) throws -> AnyPublisher<MovieDetailModel, any Error>
}

final class MovieUsesCasesImpl: MovieUsesCases {
    
    private let repository: MovieProductService
    typealias PublisherResult = AnyPublisher<MovieModel, Error>
    
    init(repository: MovieProductService = MovieProductServiceImpl()) {
        self.repository = repository
    }
    
    func executeNowPlayingMovies() throws -> PublisherResult {
        return try repository.fetchMoviesProducts(basePath: Constants.movieGeneralPath, endingPath: .nowPlaying)
    }
    
    func executeTopRatedMovies() throws -> PublisherResult {
        return try repository.fetchMoviesProducts(basePath: Constants.movieGeneralPath, endingPath: .topRated)
    }
    
    func executeUpcomingMovies() throws -> PublisherResult {
        return try repository.fetchMoviesProducts(basePath: Constants.movieGeneralPath, endingPath: .upcoming)
    }
    
    func executeTrendingMovies(timePeriod: MovieEndingPath) throws -> PublisherResult {
        return try repository.fetchMoviesProducts(basePath: Constants.trendingMovies, endingPath: timePeriod)
    }
    
    func executeDetailMovies(id: String) throws -> AnyPublisher<MovieDetailModel, any Error> {
        return try repository.fetchDetailMovie(basePath: Constants.movieGeneralPath, endingPath: .id(id))
    }
    
}
