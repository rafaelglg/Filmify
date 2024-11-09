//
//  MovieViewModel.swift
//  RafaDBPlayer
//
//  Created by Rafael Loggiodice on 6/11/24.
//

import Foundation
import Combine

@Observable
final class MovieViewModel {
    let networkManager: any NetworkManagerProtocol
    
    var nowPlayingMovies: [MovieResultResponse] = []
    var topRatedMovies: [MovieResultResponse] = []
    var upcomingMovies: [MovieResultResponse] = []
    var trendingMoviesByDay: [MovieResultResponse] = []
    var trendingMoviesByWeek: [MovieResultResponse] = []
    
    var selectedMovie: MovieResultResponse?
    var cancellable = Set<AnyCancellable>()
    
    var showProfile: Bool = false
    var alertMessage: String = ""
    
    init(networkManager: any NetworkManagerProtocol = NetworkManager.shared) {
        self.networkManager = networkManager
    }
    
    func getNowPlayingMovies() {
        do {
            try networkManager.fetchNowPlayingMovies(basePath: Constants.movieGeneralPath, endingPath: .nowPlaying)
                .eraseToAnyPublisher()
                .map(\.results)
                .receive(on: DispatchQueue.main)
                .sink { [weak self] completion in
                    switch completion {
                        
                    case .finished:
                        break
                    case .failure(let error):
                        self?.alertMessage = error.localizedDescription
                    }
                } receiveValue: { [weak self] movieResponse in
                    self?.nowPlayingMovies = movieResponse
                }
                .store(in: &cancellable)
            
        } catch {
            self.alertMessage = error.localizedDescription
        }
    }
    
    func getTopRatedMovies() {
        do {
            try networkManager.fetchNowPlayingMovies(basePath: Constants.movieGeneralPath, endingPath: .topRated)
                .eraseToAnyPublisher()
                .map(\.results)
                .receive(on: DispatchQueue.main)
                .sink { [weak self] completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        self?.alertMessage = error.localizedDescription
                    }
                } receiveValue: { [weak self] ratedMovies in
                    self?.topRatedMovies = ratedMovies
                }
                .store(in: &cancellable)
            
        } catch {
            
            self.alertMessage = error.localizedDescription
            
        }
    }
    
    func getUpcomingMovies() {
        do {
            try networkManager.fetchNowPlayingMovies(basePath: Constants.movieGeneralPath, endingPath: .upcoming)
                .eraseToAnyPublisher()
                .map(\.results)
                .sink { [weak self] completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        self?.alertMessage = error.localizedDescription
                    }
                } receiveValue: { [weak self] upcoming in
                    self?.upcomingMovies = upcoming
                }
                .store(in: &cancellable)
            
        } catch {
            self.alertMessage = error.localizedDescription
        }
    }
    
    func getTrendingMovies(timePeriod: MovieEndingPath) {
        
        do {
            guard timePeriod.isTrendingAllow else {
                throw ErrorManager.badChosenTimePeriod
            }
        } catch {
            self.alertMessage = error.localizedDescription
        }
        
        do {
            try networkManager.fetchNowPlayingMovies(basePath: Constants.trendingMovies, endingPath: timePeriod)
                .eraseToAnyPublisher()
                .receive(on: DispatchQueue.main)
                .map(\.results)
                .sink { [weak self] completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        self?.alertMessage = error.localizedDescription
                    }
                } receiveValue: { [weak self] moviesByTimePeriod in
                    
                    if timePeriod == .day {
                        self?.trendingMoviesByDay = moviesByTimePeriod
                    } else if timePeriod == .week {
                        self?.trendingMoviesByWeek = moviesByTimePeriod
                    }
                }
                .store(in: &cancellable)
            
        } catch {
            self.alertMessage = error.localizedDescription
        }
    }
    
    func getDashboard() {
        getNowPlayingMovies()
        getTopRatedMovies()
        getUpcomingMovies()
        getTrendingMovies(timePeriod: .day)
        getTrendingMovies(timePeriod: .week)
    }
}
