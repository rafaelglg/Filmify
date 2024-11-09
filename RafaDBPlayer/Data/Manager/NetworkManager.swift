//
//  NetworkManager.swift
//  RafaDBPlayer
//
//  Created by Rafael Loggiodice on 6/11/24.
//

import Foundation
import Combine

protocol NetworkManagerProtocol: AnyObject {
    associatedtype PublisherReturn: Publisher<MovieModel, Error>
    func fetchNowPlayingMovies(basePath: String, endingPath path: MovieEndingPath) throws -> PublisherReturn
}

@Observable
final class NetworkManager: Sendable, NetworkManagerProtocol {
    static let shared = NetworkManager()
    
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
    
    func fetchNowPlayingMovies(basePath: String, endingPath path: MovieEndingPath) throws -> some Publisher<MovieModel, Error> {
        
        let request = try handleURL(url: Utils.movieURL(basePath: basePath, endingPath: path))
        
        let publisher = URLSession.shared.dataTaskPublisher(for: request)
            .receive(on: DispatchQueue.main)
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
}
