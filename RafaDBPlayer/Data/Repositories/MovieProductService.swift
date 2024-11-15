//
//  MovieProductService.swift
//  RafaDBPlayer
//
//  Created by Rafael Loggiodice on 15/11/24.
//

import Combine

protocol MovieProductService {
    func fetchMoviesProducts(basePath: String, endingPath: MovieEndingPath) throws -> AnyPublisher<MovieModel, Error>
    func fetchDetailMovie(basePath: String, endingPath: MovieEndingPath) throws -> AnyPublisher<MovieDetailModel, Error>
}

final class MovieProductServiceImpl: MovieProductService {
    private let networkService: NetworkServiceProtocol
    
    init(productService: NetworkServiceProtocol = NetworkService.shared) {
        self.networkService = productService
    }
    
    func fetchMoviesProducts(basePath: String, endingPath: MovieEndingPath) throws -> AnyPublisher<MovieModel, Error> {
        return try networkService.fetchNowPlayingMovies(basePath: basePath, endingPath: endingPath)
    }
    
    func fetchDetailMovie(basePath: String, endingPath: MovieEndingPath) throws -> AnyPublisher<MovieDetailModel, Error> {
        return try networkService.fetchDetailMovies(basePath: basePath, endingPath: endingPath)
    }
    
}
