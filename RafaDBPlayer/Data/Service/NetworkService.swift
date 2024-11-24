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
    
    func fetchMovieReviews(endingPath path: MovieEndingPath) throws -> AnyPublisher<MovieReviewModel, Error>
    
    func fetchCastMembers<T: Decodable>(baseURL: String, id path: MovieEndingPath, endingPath: MovieEndingPath) throws -> AnyPublisher<T, Error>
    
    func fetchDetailMovies<T: Decodable>(id: MovieEndingPath, endingPath path: [MovieEndingPath]) throws -> AnyPublisher<T, Error>
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
    
    func fetchDetailMovies<T: Decodable>(id: MovieEndingPath, endingPath path: [MovieEndingPath]) throws -> AnyPublisher<T, Error> {

        let request = try handleURL(url: Utils.movieAppendURL(id: id, endingPath: path))
        
        return URLSession.shared
            .dataTaskPublisher(for: request)
            .tryMap(handleResponse)
            .decode(type: T.self, decoder: Utils.jsonDecoder)
            .eraseToAnyPublisher()
            
    }
    
    func fetchMovieReviews(endingPath path: MovieEndingPath) throws -> AnyPublisher <MovieReviewModel, Error> {
        
        let request = try handleURL(url: Utils.movieURL(baseURL: Constants.movieGeneralPath, id: path, endingPath: .reviews))
        
        let publisher = URLSession.shared.dataTaskPublisher(for: request)
            .tryMap(handleResponse)
            .decode(type: MovieReviewModel.self, decoder: Utils.jsonDecoder)
            .eraseToAnyPublisher()
        
        return publisher
    }
    
    func fetchCastMembers<T: Decodable>(baseURL: String, id path: MovieEndingPath, endingPath: MovieEndingPath) throws -> AnyPublisher<T, Error> {
        
        let request = try handleURL(url: Utils.movieURL(baseURL: baseURL, id: path, endingPath: endingPath))
        
        return URLSession.shared
            .dataTaskPublisher(for: request)
            .tryMap(handleResponse)
            .decode(type: T.self, decoder: Utils.jsonDecoder)
            .eraseToAnyPublisher()
    }

}
