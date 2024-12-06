//
//  NetworkServiceTest.swift
//  NetworkServiceTest
//
//  Created by Rafael Loggiodice on 6/12/24.
//

import Testing
import Combine
@testable import RafaDBPlayer

struct NetworkServiceTest {
    
    let sut: NetworkServiceProtocol
    var networkMock = NetworkServiceMock()
    
    init(sut: NetworkServiceProtocol = NetworkServiceMock()) {
        self.networkMock = NetworkServiceMock()
        self.sut = networkMock
    }
    
    @Test("Now playing videos",
          arguments: [
            "nowPlaying",
            "now platying 2nd argument",
          ])
    func fetchNowplayingMovies_ResultOK(basePath: String) {
        var cancellable = Set<AnyCancellable>()
        var movieResponse: MovieResultResponse?
        
        sut.fetchNowPlayingMovies(basePath: basePath, endingPath: .nowPlaying)
            .sink { completion in
                switch completion {
                    
                case .finished:
                    #expect(networkMock.basePathMock == basePath)
                case .failure(let error):
                    Issue.record(error, "The test should't fail and failed.")
                }
            } receiveValue: { movieResult in
                if let movieFirst = movieResult.results.first {
                    movieResponse = movieFirst
                    #expect(movieFirst.overview == movieResponse?.overview)
                    #expect(movieFirst.id == movieResponse?.id)
                    #expect(movieFirst.title == movieResponse?.title)
                }
            }
            .store(in: &cancellable)
    }
    
    @Test("Movie reviews", arguments: [MovieEndingPath.reviews])
    func fetchMovieReviews_ResultOK(endingPath: MovieEndingPath) {
        var cancellable = Set<AnyCancellable>()
        
        sut.fetchMovieReviews(endingPath: endingPath)
            .sink { completion in
                switch completion {
                    
                case .finished:
                    #expect(endingPath == MovieEndingPath.reviews)
                case .failure(let error):
                    Issue.record(error, "The test should't fail and failed.")
                }
            } receiveValue: { response in
                networkMock.movieReviewMock = response
                #expect(response != nil, "The result cannot be nil")
                #expect(response == networkMock.movieReviewMock)
            }
            .store(in: &cancellable)
    }
    
    @Test("fetch castMembers",arguments: ["base url 1", "base url 2"],[MovieEndingPath.id("hola")])
    func fetchCastMembers_ResultOK(baseURL: String, id: MovieEndingPath) {
        var cancellable = Set<AnyCancellable>()
        
        sut.fetchCastMembers(baseURL: baseURL, id: id, endingPath: .castMembers)
            .sink { completion in
                switch completion {
                    
                case .finished:
                    #expect(networkMock.basePathMock == baseURL)
                    #expect(networkMock.idMock == id)
                case .failure(let error):
                    Issue.record(error, "The test should't fail and failed.")
                }
            } receiveValue: { (response: CastModel) in
                
                networkMock.castMock = response
                #expect(response != nil, "The result cannot be nil")
                #expect(response == networkMock.castMock)
            }
            .store(in: &cancellable)
    }
    
}

final class NetworkServiceMock: NetworkServiceProtocol {
    
    var movieModelMock = MovieModel(page: 1, results: [.preview])
    var movieReviewMock = MovieReviewModel(page: 1, results: [.preview])
    var castMock = CastModel(
        id: 1, cast: CastResponseModel.preview, crew: CrewResponseModel.preview)
    var movieDetailMock = MovieDetails.preview
    var basePathMock: String = ""
    var idMock: MovieEndingPath = .none
    
    func fetchNowPlayingMovies(
        basePath: String, endingPath path: MovieEndingPath
    ) -> AnyPublisher<MovieModel, Error> {
        basePathMock = basePath
        return Just(movieModelMock)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    func fetchMovieReviews(endingPath path: MovieEndingPath) -> AnyPublisher<
        MovieReviewModel, Error
    > {
        
        return Just(movieReviewMock)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    func fetchCastMembers<T>(
        baseURL: String, id path: MovieEndingPath, endingPath: MovieEndingPath
    ) -> AnyPublisher<T, Error> where T: Decodable {
        basePathMock = baseURL
        idMock = path
        
        guard let castMock = castMock as? T else {
            return Fail(error: ErrorManager.badURL)
                .eraseToAnyPublisher()
        }
        
        return Just(castMock)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    func fetchDetailMovies<T>(
        id: MovieEndingPath, endingPath path: [MovieEndingPath]
    ) -> AnyPublisher<T, Error> where T: Decodable {
        
        idMock = id
        
        guard let movieDetail = movieDetailMock as? T else {
            return Fail(error: ErrorManager.badURL)
                .eraseToAnyPublisher()
        }
        
        return Just(movieDetail)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    func fetchSearchMovies<T>(query: String) -> AnyPublisher<T, Error>
    where T: Decodable {
        
        basePathMock = query
        
        guard let movieModel = movieModelMock as? T else {
            return Fail(error: ErrorManager.badURL)
                .eraseToAnyPublisher()
        }
        
        return Just(movieModel)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
