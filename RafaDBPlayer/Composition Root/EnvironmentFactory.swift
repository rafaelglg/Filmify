//
//  EnvironmentFactory.swift
//  RafaDBPlayer
//
//  Created by Rafael Loggiodice on 19/12/24.
//

@MainActor
final class EnvironmentFactory {
    static let authViewModel = AuthViewModelImpl()
    static let appState = AppStateImpl()
    static let network = NetworkMonitorImpl()
    static let movieVM = MovieViewModel(movieUsesCase: AppStarterFactory.createMovieUseCase())
}
