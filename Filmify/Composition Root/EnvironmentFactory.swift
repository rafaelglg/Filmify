//
//  EnvironmentFactory.swift
//  Filmify
//
//  Created by Rafael Loggiodice on 19/12/24.
//

@MainActor
final class EnvironmentFactory {
    static let authViewModel = createAuthViewModel()
    static let appState = AppStateImpl()
    static let network = NetworkMonitorImpl()
    static let movieVM = MovieViewModel(movieUsesCase: AppStarterFactory.createMovieUseCase())
    
    private init() {}
    
    static private func createAuthViewModel() -> AuthViewModelImpl {
        AuthViewModelImpl(biometricAuthentication: createBiometricAuthentication(),
                          authManager: createAuthManager(),
                          keychain: createKeychain(),
                          createSession: createGuestUseCase())
    }
    
    static func createGuestUseCase() -> CreateSessionUseCase {
        CreateSessionUseCaseImpl(repository: createGuestRepositoty())
    }
    
    static func createGuestRepositoty() -> CreateSessionService {
        CreateSessionServiceImpl(networkService: NetworkServiceImpl.shared)
    }
    
    static private func createKeychain() -> KeychainManager {
        KeychainManagerImpl.shared
    }
    
    static private func createBiometricAuthentication() -> BiometricAuthentication {
        BiometricAuthenticationImpl()
    }
    
    static private func createAuthManager() -> AuthManager {
        AuthManagerImpl(userBuilder: createUserBuilder())
    }
    
    static private func createUserBuilder() -> UserBuilder {
        UserBuilderImpl()
    }
    
    static func createNetworkService() -> NetworkServiceImpl {
        NetworkServiceImpl.shared
    }
}
