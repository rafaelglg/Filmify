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
    var searchText = CurrentValueSubject<String, Never>("")
    var filteredMovies: [MovieResultResponse] = []
    var noSearchResult: Bool = false
    
    var showProfile: Bool = false
    var isLoading: Bool = false
    var alertMessage: String = ""
    
    init(movieUsesCase: MovieUsesCases = MovieUsesCasesImpl()) {
        self.movieUsesCase = movieUsesCase
        addSubscribers()
    }
    
    var isSearching: Bool {
        !searchText.value.isEmpty
    }
    
    func getNowPlayingMovies() {
        
        movieUsesCase.executeNowPlayingMovies()
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
    }
    
    func getTopRatedMovies() {
        
        movieUsesCase.executeTopRatedMovies()
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
    }
    
    func getUpcomingMovies() {
        
        movieUsesCase.executeUpcomingMovies()
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
    }
    
    func getTrendingMovies(timePeriod: MovieEndingPath) {
        
        do {
            guard timePeriod.isTrendingAllow else {
                throw ErrorManager.badChosenTimePeriod
            }
        } catch {
            self.alertMessage = error.localizedDescription
        }
        
        movieUsesCase.executeTrendingMovies(timePeriod: timePeriod)
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
    }
    
    func getMovieDetails(id: String?) {
        isLoading = true
        
        movieUsesCase.executeDetailMovies(id: id ?? "0")
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
    }
    
    func getSearch(query: String) {
        movieUsesCase.executeSearch(query: query)
            .receive(on: DispatchQueue.main)
            .map(\.results)
            .sink { completion in
                switch completion {
                case .finished: break
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: { [weak self] searchedMovies in
                self?.filteredMovies = searchedMovies
                self?.noSearchResult = searchedMovies.isEmpty
            }.store(in: &cancellable)
    }
    
    func getDashboard() {
        getNowPlayingMovies()
        getTopRatedMovies()
        getUpcomingMovies()
        getTrendingMovies(timePeriod: .day)
        getTrendingMovies(timePeriod: .week)
    }
}

extension MovieViewModel {
    func addSubscribers() {
        searchText
            .debounce(for: 0.3, scheduler: DispatchQueue.main)
            .sink { [weak self] searchedText in
                if !searchedText.isEmpty {
                    self?.getSearch(query: searchedText)
                }
            }
            .store(in: &cancellable)
    }
}
