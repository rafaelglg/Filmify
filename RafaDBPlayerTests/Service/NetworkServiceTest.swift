//
//  NetworkServiceTest.swift
//  NetworkServiceTest
//
//  Created by Rafael Loggiodice on 6/12/24.
//

import Foundation
import Testing
import Combine
@testable import RafaDBPlayer

extension Tag {
    @Tag static var resultOK: Self
    @Tag static var resultKO: Self
}

@Suite("Network service")
struct NetworkServiceTest {
    
    let sut: NetworkServiceProtocol
    var networkMock = NetworkServiceMock()
    
    init(sut: NetworkServiceProtocol = NetworkServiceMock()) {
        self.sut = networkMock
    }
    
    @Test("Now playing videos", .tags(.resultOK),
          arguments: [
            "nowPlaying",
            "now platying 2nd argument"
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
    
    @Test("Movie reviews", .tags(.resultOK), arguments: [MovieEndingPath.reviews])
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
    
    @Test("fetch castMembers", .tags(.resultOK), arguments: ["base url 1", "base url 2"], [MovieEndingPath.id("hola")])
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
    
    @Test("fetch detail Movies", .tags(.resultOK))
    func fetchDetailMovies_ResultOK() {
        var cancellable = Set<AnyCancellable>()
        
        sut.fetchDetailMovies(id: .id("test"), endingPath: [.videos])
            .sink { completion in
                switch completion {
                case .finished:
                    #expect(networkMock.idMock == .id("test"))
                case .failure(let error):
                    Issue.record(error, "The test should't fail and failed.")
                }
            } receiveValue: { (response: MovieDetails) in
                networkMock.movieDetailMock = response
                
                #expect( networkMock.movieDetailMock != nil)
                #expect(response.posterPath == networkMock.movieDetailMock.posterPath)
                #expect(response.status == networkMock.movieDetailMock.status)
                
            }.store(in: &cancellable)
    }
    
    @Test("Search movies", .tags(.resultOK))
    func fetchSearchMovies() {
        var cancellable = Set<AnyCancellable>()
        var movieResponse: MovieResultResponse?
        
        sut.fetchSearchMovies(query: "searching")
            .sink { completion in
                switch completion {
                    
                case .finished:
                    #expect(networkMock.basePathMock == "searching")
                case .failure(let error):
                    Issue.record(error)
                }
            } receiveValue: { (response: MovieModel) in
                let responseFirst = response.results.first
                movieResponse = responseFirst
                #expect(responseFirst?.id == movieResponse?.id)
                #expect(responseFirst?.overview == movieResponse?.overview)
            }.store(in: &cancellable)
    }
    
    // MARK: - Result KO
    
    @Test("Now playing videos Result KO", .tags(.resultKO))
    func fetchNowplayingMovies_ResultKO() {
        
        var cancellable = Set<AnyCancellable>()
        networkMock.shouldReturnError = true
        
        sut.fetchNowPlayingMovies(basePath: "", endingPath: .nowPlaying)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    #expect(error as? URLError == URLError(.badServerResponse))
                }
            } receiveValue: { _ in
                Issue.record("The test should't pass and passed.")
            }
            .store(in: &cancellable)
    }
    
    @Test("Movie reviews result KO", .tags(.resultKO))
    func fetchMovieReviews_ResultKO() {
        
        var cancellable = Set<AnyCancellable>()
        networkMock.shouldReturnError = true
        
        sut.fetchMovieReviews(endingPath: .reviews)
            .sink { completion in
                switch completion {
                    
                case .finished:
                    break
                case .failure(let error):
                    #expect(error as? URLError == URLError(.badServerResponse))
                }
            } receiveValue: { _ in
                Issue.record("The test should't pass and passed.")
            }
            .store(in: &cancellable)
    }
    
    @Test("fetch castMembers result KO", .tags(.resultKO))
    func fetchCastMembers_ResultkO() {
        
        var cancellable = Set<AnyCancellable>()
        networkMock.shouldReturnError = true
        
        sut.fetchCastMembers(baseURL: "", id: .id(""), endingPath: .castMembers)
            .sink { completion in
                switch completion {
                    
                case .finished:
                    break
                case .failure(let error):
                    #expect(error as? ErrorManager == ErrorManager.badURL)
                }
            } receiveValue: { (_: MovieDetails) in
                Issue.record("The test should't pass and passed.")
            }
            .store(in: &cancellable)
    }
    
    @Test("fetch detail Movies result KO", .tags(.resultKO))
    func fetchDetailMovies_ResultKO() {
        
        var cancellable = Set<AnyCancellable>()
        networkMock.shouldReturnError = true
        
        sut.fetchDetailMovies(id: .id("test"), endingPath: [.videos])
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    #expect(error as? ErrorManager == ErrorManager.badURL)
                }
            } receiveValue: { (_: CastResponseModel) in
                Issue.record("The test should't pass and passed.")
                
            }.store(in: &cancellable)
    }
    
    @Test("Search movies result KO", .tags(.resultKO))
    func fetchSearchMovies_ResultKO() {
        
        var cancellable = Set<AnyCancellable>()
        networkMock.shouldReturnError = true
        
        sut.fetchSearchMovies(query: "searching")
            .sink { completion in
                switch completion {
                    
                case .finished:
                    break
                case .failure(let error):
                    #expect(error as? ErrorManager == ErrorManager.badURL)
                }
            } receiveValue: { (_: MovieResultResponse) in
                Issue.record("The test should't pass and passed.")
            }.store(in: &cancellable)
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
    var shouldReturnError: Bool = false
    var errorToReturn: Error = URLError(.badServerResponse)
    
    func fetchNowPlayingMovies(basePath: String, endingPath path: MovieEndingPath) -> AnyPublisher<MovieModel, Error> {
        basePathMock = basePath
        
        if shouldReturnError {
            return Fail(error: errorToReturn).eraseToAnyPublisher()
        } else {
            return Just(movieModelMock)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
    }
    
    func fetchMovieReviews(endingPath path: MovieEndingPath) -> AnyPublisher<MovieReviewModel, Error> {
        
        if shouldReturnError {
            return Fail(error: errorToReturn).eraseToAnyPublisher()
        } else {
            return Just(movieReviewMock)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
    }
    
    func fetchCastMembers<T>(baseURL: String, id path: MovieEndingPath, endingPath: MovieEndingPath) -> AnyPublisher<T, Error> where T: Decodable {
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
    
    func fetchDetailMovies<T>(id: MovieEndingPath, endingPath path: [MovieEndingPath]) -> AnyPublisher<T, Error> where T: Decodable {
        
        idMock = id
        
        guard let movieDetail = movieDetailMock as? T else {
            return Fail(error: ErrorManager.badURL)
                .eraseToAnyPublisher()
        }
        
        return Just(movieDetail)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    func fetchSearchMovies<T>(query: String) -> AnyPublisher<T, Error> where T: Decodable {
        
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
