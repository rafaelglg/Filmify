//
//  MovieProductService.swift
//  Filmify
//
//  Created by Rafael Loggiodice on 15/11/24.
//

import Combine

protocol MovieProductService {
    func fetchMoviesProducts(basePath: String, endingPath: MovieEndingPath) -> AnyPublisher<MovieModel, Error>
    func fetchDetailMovie(id: MovieEndingPath, endingPath: [MovieEndingPath]) -> AnyPublisher<MovieDetails, Error>
    func fetchSearchMovies(query: String) -> AnyPublisher<MovieModel, Error>
}

final class MovieProductServiceImpl: MovieProductService {
    private let networkService: NetworkService
    
    init(productService: NetworkService) {
        self.networkService = productService
    }
    
    func fetchMoviesProducts(basePath: String, endingPath: MovieEndingPath) -> AnyPublisher<MovieModel, Error> {
        return networkService.fetchNowPlayingMovies(basePath: basePath, endingPath: endingPath)
    }
    
    func fetchDetailMovie(id: MovieEndingPath, endingPath: [MovieEndingPath]) -> AnyPublisher<MovieDetails, Error> {
        return networkService.fetchDetailMovies(id: id, endingPath: endingPath)
    }
    
    func fetchSearchMovies(query: String) -> AnyPublisher<MovieModel, Error> {
        return networkService.fetchSearchMovies(query: query)
    }
}
