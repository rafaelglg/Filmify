//
//  NetworkService.swift
//  RafaDBPlayer
//
//  Created by Rafael Loggiodice on 6/11/24.
//

import Foundation
import Combine

protocol NetworkServiceProtocol: AnyObject {
    
    func fetchNowPlayingMovies(basePath: String, endingPath path: MovieEndingPath) throws -> AnyPublisher<MovieModel, Error>
    func fetchDetailMovies(basePath: String, endingPath path: MovieEndingPath) throws -> AnyPublisher<MovieDetailModel, Error>
    func fetchMovieReviews(endingPath path: MovieEndingPath) throws -> AnyPublisher<MovieReviewModel, Error>
}

final class NetworkService: Sendable, NetworkServiceProtocol {
    static let shared = NetworkService()
    
    private init() {}
    
    func handleResponse(output: URLSession.DataTaskPublisher.Output) throws -> Data {
        guard let response = output.response as? HTTPURLResponse, response.statusCode >= 200 && response.statusCode < 300 else {
            throw ErrorManager.badServerResponse
        }
        return output.data
    }
    
    func handleURL(url: String) throws -> URLRequest {
        guard let url = URL(string: url) else {
            throw ErrorManager.badURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(ApiKey.movieToken)", forHTTPHeaderField: "Authorization")
        
        return request
        
    }
    
    func fetchNowPlayingMovies(basePath: String, endingPath path: MovieEndingPath) throws -> AnyPublisher<MovieModel, Error> {
        
        let request = try handleURL(url: Utils.movieURL(basePath: basePath, endingPath: path))
        
        let publisher = URLSession.shared.dataTaskPublisher(for: request)
            .tryMap(handleResponse)
            .mapError { error -> Error in
                if (error as? URLError)?.code == .unsupportedURL {
                    return ErrorManager.badURL
                }
                
                return error
            }
            .decode(type: MovieModel.self, decoder: Utils.jsonDecoder)
            .eraseToAnyPublisher()
        
        return publisher
    }
    
    func fetchDetailMovies(basePath: String, endingPath path: MovieEndingPath) throws -> AnyPublisher<MovieDetailModel, Error> {
        
        let request = try handleURL(url: Utils.movieURL(basePath: basePath, endingPath: path))
        
        return URLSession.shared
            .dataTaskPublisher(for: request)
            .tryMap(handleResponse)
            .decode(type: MovieDetailModel.self, decoder: Utils.jsonDecoder)
            .eraseToAnyPublisher()
            
    }
    
    func fetchMovieReviews(endingPath path: MovieEndingPath) throws -> AnyPublisher <MovieReviewModel, Error> {
        
        let request = try handleURL(url: Utils.movieReviewURL(id: path))
        
        let publisher = URLSession.shared.dataTaskPublisher(for: request)
            .tryMap(handleResponse)
            .decode(type: MovieReviewModel.self, decoder: Utils.jsonDecoder)
            .eraseToAnyPublisher()
        
        return publisher
    }
    
}
