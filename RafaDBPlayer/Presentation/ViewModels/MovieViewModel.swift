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
    let movieUsesCase: MovieUsesCases
    
    var nowPlayingMovies: [MovieResultResponse] = []
    var topRatedMovies: [MovieResultResponse] = []
    var upcomingMovies: [MovieResultResponse] = []
    var trendingMoviesByDay: [MovieResultResponse] = []
    var trendingMoviesByWeek: [MovieResultResponse] = []
    var detailMovie: MovieDetails = .preview
    
    var selectedMovie: MovieResultResponse?
    var cancellable = Set<AnyCancellable>()
    
    var showProfile: Bool = false
    var isLoading: Bool = false
    var alertMessage: String = ""
    
    init(movieUsesCase: MovieUsesCases = MovieUsesCasesImpl()) {
        self.movieUsesCase = movieUsesCase
    }
    
    func getNowPlayingMovies() {
        do {
            try movieUsesCase.executeNowPlayingMovies()
                .receive(on: DispatchQueue.main)
                .map(\.results)
                .sink { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        self.alertMessage = error.localizedDescription
                    }
                } receiveValue: { [weak self] movieResponse in
                    self?.nowPlayingMovies = movieResponse
                }.store(in: &cancellable)

        } catch {
            self.alertMessage = error.localizedDescription
        }
    }
    
    func getTopRatedMovies() {
        do {
            try movieUsesCase.executeTopRatedMovies()
                .receive(on: DispatchQueue.main)
                .map(\.results)
                .sink { [weak self] completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        self?.alertMessage = error.localizedDescription
                    }
                } receiveValue: { [weak self] ratedMovies in
                    self?.topRatedMovies = ratedMovies
                }.store(in: &cancellable)
        } catch {
            self.alertMessage = error.localizedDescription
        }
    }
    
    func getUpcomingMovies() {
        do {
            try movieUsesCase.executeUpcomingMovies()
                .eraseToAnyPublisher()
                .map(\.results)
                .sink { [weak self] completion in
                    switch completion {
                    case .finished: break
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
            try movieUsesCase.executeTrendingMovies(timePeriod: timePeriod)
                .eraseToAnyPublisher()
                .receive(on: DispatchQueue.main)
                .map(\.results)
                .sink { [weak self] completion in
                    switch completion {
                    case .finished: break
                    case .failure(let error):
                        self?.alertMessage = error.localizedDescription
                    }
                } receiveValue: { [weak self] moviesByTimePeriod in
                    
                    if timePeriod == MovieEndingPath.day {
                        self?.trendingMoviesByDay = moviesByTimePeriod
                    } else if timePeriod == MovieEndingPath.week {
                        self?.trendingMoviesByWeek = moviesByTimePeriod
                    }
                }
                .store(in: &cancellable)
            
        } catch {
            self.alertMessage = error.localizedDescription
        }
    }
    
    func getMovieDetails(id: String?) {
        isLoading = true
        do {
            try movieUsesCase.executeDetailMovies(id: id ?? "0")
                .eraseToAnyPublisher()
                .receive(on: DispatchQueue.main)
                .sink { [weak self] completion in
                    guard let self else { return }
                    
                    defer {
                        self.isLoading = false
                    }
                    
                    switch completion {
                    case .finished: break
                    case .failure(let error):
                        self.alertMessage = error.localizedDescription
                    }
                } receiveValue: { [weak self] detailMovieResponse in
                    self?.detailMovie = detailMovieResponse
                }
                .store(in: &cancellable)
            
        } catch {
            isLoading = false
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
