//
//  NetworkServiceImpl.swift
//  Filmify
//
//  Created by Rafael Loggiodice on 6/11/24.
//

import Foundation
import Combine

protocol NetworkService: AnyObject {
    
    func fetchNowPlayingMovies(basePath: String, endingPath path: MovieEndingPath) -> AnyPublisher<MovieModel, Error>
    func fetchMovieReviews(endingPath path: MovieEndingPath) -> AnyPublisher<MovieReviewModel, Error>
    func fetchCastMembers<T: Decodable>(baseURL: String, id path: MovieEndingPath, endingPath: MovieEndingPath) -> AnyPublisher<T, Error>
    func fetchDetailMovies<T: Decodable>(id: MovieEndingPath, endingPath path: [MovieEndingPath]) -> AnyPublisher<T, Error>
    
    func fetchSearchMovies<T: Decodable>(query: String) -> AnyPublisher<T, Error>
    
    func createToken() -> AnyPublisher<TokenResponseModel, Error>
    func fetchGuestResponse() -> AnyPublisher<GuestModel, Error>
    func postRatingToMovie(movieId: MovieEndingPath, ratingValue: Float) -> AnyPublisher<RatingResponseModel, Error>
    func createSessionID(token: String) -> AnyPublisher<SessionIdResponseModel, Error>
    func deleteSessionID(sessionId: String) -> AnyPublisher<DeleteSessionIdResponseModel, Error>
}

final class NetworkServiceImpl: Sendable, NetworkService {
    static let shared = NetworkServiceImpl()
    
    private init() {}
    
    func handleResponse(output: URLSession.DataTaskPublisher.Output) throws -> Data {
        guard let response = output.response as? HTTPURLResponse, response.statusCode >= 200 && response.statusCode < 300 else {
            throw ErrorManager.badServerResponse
        }
        return output.data
    }
    
    func handleRequest(url: String, method: HTTPMethod = .get, body: [String: Any]? = nil) -> URLRequest {
        guard let url = URL(string: url) else {
            return URLRequest(url: URL(filePath: "empty url"))
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.setValue("Bearer \(ApiKey.movieToken)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        if let body = body {
            do {
                // This value is set to POST https methods
                request.setValue("application/json;charset=utf-8", forHTTPHeaderField: "Content-Type")
                request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
            } catch {
                fatalError("Failed to serialize JSON body: \(error.localizedDescription)")
            }
        }
        return request
    }
}

extension NetworkServiceImpl {
    
    // MARK: - Search movie Methods
    func fetchSearchMovies<T: Decodable>(query: String) -> AnyPublisher<T, Error> {
        
        let request = handleRequest(url: "https://api.themoviedb.org/3/search/movie?query=\(query)&\(Utils.getCurrentLanguage)")
        
        return URLSession.shared
            .dataTaskPublisher(for: request)
            .tryMap(handleResponse)
            .mapError { error -> Error in
                if (error as? URLError)?.code == .unsupportedURL {
                    return ErrorManager.badURL
                }
                return error
            }
            .decode(type: T.self, decoder: Utils.jsonDecoder)
            .eraseToAnyPublisher()
    }
    
    // MARK: - Sign in methods with movieDB
    
    func fetchGuestResponse() -> AnyPublisher<GuestModel, Error> {
        
        let request = handleRequest(url: Constants.guestSessionPath)
        
        let publisher = URLSession.shared.dataTaskPublisher(for: request)
            .tryMap(handleResponse)
            .mapError { error -> Error in
                if (error as? URLError)?.code == .unsupportedURL {
                    return ErrorManager.badURL
                }
                return error
            }
            .decode(type: GuestModel.self, decoder: Utils.jsonDecoder)
            .eraseToAnyPublisher()
        return publisher
    }
    
    func postRatingToMovie(movieId: MovieEndingPath, ratingValue: Float) -> AnyPublisher<RatingResponseModel, Error> {
        
        let body: [String: Any] = ["value": ratingValue]
        let request = handleRequest(url: "\(Constants.movieGeneralPath + movieId.pathValue)/rating",
                                    method: .post,
                                    body: body)
        
        let publisher = URLSession.shared.dataTaskPublisher(for: request)
            .tryMap(handleResponse)
            .mapError { error -> Error in
                if (error as? URLError)?.code == .unsupportedURL {
                    return ErrorManager.badURL
                }
                return error
            }
            .decode(type: RatingResponseModel.self, decoder: Utils.jsonDecoder)
            .eraseToAnyPublisher()
        return publisher
    }
    
    func createToken() -> AnyPublisher<TokenResponseModel, Error> {
        
        let request = handleRequest(url: Constants.createTokenPath)
        
        let publisher = URLSession.shared.dataTaskPublisher(for: request)
            .tryMap(handleResponse)
            .decode(type: TokenResponseModel.self, decoder: Utils.jsonDecoder)
            .eraseToAnyPublisher()
        
        return publisher
    }
    
    func createSessionID(token: String) -> AnyPublisher<SessionIdResponseModel, Error> {
        let body: [String: Any] = [
            "request_token": token
        ]
        let request = handleRequest(url: Constants.createNewSessionPath, method: .post, body: body)
        
        let publisher = URLSession.shared.dataTaskPublisher(for: request)
            .tryMap(handleResponse)
            .decode(type: SessionIdResponseModel.self, decoder: Utils.jsonDecoder)
            .eraseToAnyPublisher()
        
        return publisher
    }
    
    func deleteSessionID(sessionId: String) -> AnyPublisher<DeleteSessionIdResponseModel, Error> {
        let body: [String: Any] = [
            "session_id": sessionId
        ]
        let request = handleRequest(url: Constants.deleteSessionIdPath, method: .delete, body: body)
        
        let publisher = URLSession.shared.dataTaskPublisher(for: request)
            .tryMap(handleResponse)
            .decode(type: DeleteSessionIdResponseModel.self, decoder: Utils.jsonDecoder)
            .eraseToAnyPublisher()
        
        return publisher
    }
    
    // MARK: - Fetch movie properties
    func fetchNowPlayingMovies(basePath: String, endingPath path: MovieEndingPath) -> AnyPublisher<MovieModel, Error> {
        
        let request = handleRequest(url: Utils.movieURL(basePath: basePath, endingPath: path))
        
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
    
    func fetchDetailMovies<T: Decodable>(id: MovieEndingPath, endingPath path: [MovieEndingPath]) -> AnyPublisher<T, Error> {
        
        let request = handleRequest(url: Utils.movieAppendURL(id: id, endingPath: path))
        
        return URLSession.shared
            .dataTaskPublisher(for: request)
            .tryMap(handleResponse)
            .decode(type: T.self, decoder: Utils.jsonDecoder)
            .eraseToAnyPublisher()
        
    }
    
    func fetchMovieReviews(endingPath path: MovieEndingPath) -> AnyPublisher <MovieReviewModel, Error> {
        
        let request = handleRequest(url: Utils.movieURL(baseURL: Constants.movieGeneralPath, id: path, endingPath: .reviews))
        
        let publisher = URLSession.shared.dataTaskPublisher(for: request)
            .tryMap(handleResponse)
            .decode(type: MovieReviewModel.self, decoder: Utils.jsonDecoder)
            .eraseToAnyPublisher()
        
        return publisher
    }
    
    func fetchCastMembers<T: Decodable>(baseURL: String, id path: MovieEndingPath, endingPath: MovieEndingPath) -> AnyPublisher<T, Error> {
        
        let request = handleRequest(url: Utils.movieURL(baseURL: baseURL, id: path, endingPath: endingPath))
        
        return URLSession.shared
            .dataTaskPublisher(for: request)
            .tryMap(handleResponse)
            .decode(type: T.self, decoder: Utils.jsonDecoder)
            .eraseToAnyPublisher()
    }
}
