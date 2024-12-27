//
//  AuthViewModel.swift
//  Filmify
//
//  Created by Rafael Loggiodice on 17/12/24.
//

import Foundation
import SwiftUI
import Combine

protocol AuthViewModel {
    var currentUser: UserModel? { get }
    var authManager: AuthManager { get }
    var authErrorMessage: String { get }
    var showErrorAlert: Bool { get }
    var guestModel: GuestModel? { get }
    var isLoading: Bool { get }
    var isLoadingSignInSession: Bool { get }
    
    func signIn(email: String, password: String)
    func signInAsGuest()
    func createUser()
    func signOut()
    func deleteUser()
}

protocol BiometricAuthenticationType {
    var biometricAuth: BiometricAuthentication { get }
    @MainActor
    func biometricAuthentication()
}

protocol KeychainAuth {
    func getkeyFromKeychain()
    func saveToKeychain(userId: String, email: String, password: String)
    func deleteFromKeychain(userID: String)
}

@Observable
final class AuthViewModelImpl: AuthViewModel {
    var currentUser: UserModel?
    var biometricAuth: BiometricAuthentication
    var authManager: AuthManager
    let createSession: CreateSessionUseCase
    let biometricErrorMessage: String = ""
    var authErrorMessage: String = ""
    var showErrorAlert: Bool = false
    let keychain: KeychainManager
    var guestModel: GuestModel?
    var isLoading: Bool = false
    var isLoadingSignInSession: Bool = false
    var urlToOpen: URL?
    var canOpenURL: Bool = false
    
    @ObservationIgnored var cancellable = Set<AnyCancellable>()
    @ObservationIgnored @AppStorage("userID") var currentUserId: String?
    
    init(biometricAuthentication: BiometricAuthentication, authManager: AuthManager, keychain: KeychainManager, createSession: CreateSessionUseCase) {
        self.biometricAuth = biometricAuthentication
        self.authManager = authManager
        self.keychain = keychain
        self.createSession = createSession
        
        if authManager.userSession != nil {
            self.loadCurrentUser()
        }
    }
    
    func signIn(email: String, password: String) {
        isLoadingSignInSession = true
        authManager.signIn(email: email, password: password)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                
                defer {
                    self?.isLoadingSignInSession = false
                }
                
                switch completion {
                    
                case .finished:
                    break
                case .failure(let error):
                    self?.authErrorMessage = error.localizedDescription
                    self?.showErrorAlert = true
                }
            } receiveValue: { [weak self] user in
                self?.currentUserId = user.id
                self?.currentUser = user
                self?.saveKeychainFromLogin(userId: user.id, email: user.email, password: password)
            }.store(in: &cancellable)
    }
    
    func createUser() {
        
        authManager.createUser()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self?.authErrorMessage = error.localizedDescription
                    self?.showErrorAlert = true
                }
            } receiveValue: { [weak self] user in
                self?.currentUser = nil
                self?.currentUserId = user.id
                self?.saveToKeychain(userId: user.id, email: user.email, password: user.password)
                self?.currentUser = user
            }.store(in: &cancellable)
    }
    
    func signOut() {
        authManager.signOut()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                    
                case .finished:
                    break
                case .failure(let error):
                    self?.authErrorMessage = error.localizedDescription
                    self?.showErrorAlert = true
                }
            } receiveValue: { [weak self]  _ in
                self?.setGuestModel(model: nil)
            }.store(in: &cancellable)
    }
    
    func deleteUser() {
        
        if authManager.userSession != nil {
            
            authManager.deleteUser()
                .receive(on: DispatchQueue.main)
                .sink { [weak self] completion in
                    switch completion {
                        
                    case .finished:
                        break
                    case .failure(let error):
                        self?.authErrorMessage = error.localizedDescription
                        self?.showErrorAlert = true
                    }
                } receiveValue: { [weak self] user in
                    self?.currentUser = nil
                    self?.deleteFromKeychain(userID: user.uid)
                    self?.clearKeychain()
                    self?.deleteSessionId(sessionId: self?.currentUser?.sessionId ?? "")
                }.store(in: &cancellable)
        } else {
            // Guest session
            setGuestModel(model: nil)
        }
    }
    
    func loadCurrentUser() {
        isLoadingSignInSession = true
        authManager.loadCurrentUser { [weak self] result in
            
            defer {
                self?.isLoadingSignInSession = false
            }
            
            switch result {
            case .success(let user):
                self?.currentUser = user
            case .failure(let error):
                self?.authErrorMessage = error.localizedDescription
                self?.showErrorAlert = true
            }
        }
    }
    
    func setGuestModel(model: GuestModel?) {
        withAnimation {
            currentUser = UserModel(id: "1", email: "", password: "", fullName: "Guest", sessionId: "")
            guestModel = model
            
            if guestModel == nil {
                currentUser = nil
            }
        }
    }
}

extension AuthViewModelImpl: BiometricAuthenticationType {
    // MARK: Biometric auth methods
    @MainActor
    func biometricAuthentication() {
        
        Task {
            await biometricAuth.biometricAuthentication()
            if biometricAuth.isAuthenticated {
                do throws(KeychainError) {
                    
                    let email = try keychain.getEmail(userID: currentUserId ?? "")
                    let password = try keychain.getPassword(email: email)
                    signIn(email: email, password: password ?? "")
                } catch {
                    biometricAuth.showBiometricError(error)
                    print(error)
                    print("error no hay credentials guardados")
                }
                
            }
        }
    }
}

extension AuthViewModelImpl: KeychainAuth {
    
    // MARK: keychain methods
    func getkeyFromKeychain() {
        do {
            let email = try keychain.getEmail(userID: currentUserId ?? "")
            let password = try keychain.getPassword(email: email)
            authErrorMessage = "\(email) \(String(describing: password))"
            showErrorAlert.toggle()
        } catch {
            print(error)
            print("error")
        }
    }
    
    func getkeyFromKeychain(userId: String) {
        do {
            let emailFrom = try keychain.getEmail(userID: userId)
            print(emailFrom)
            let password = try keychain.getPassword(email: emailFrom)
            print(password ?? "none")
            authErrorMessage = "\(emailFrom) \(String(describing: password))"
            showErrorAlert = true
        } catch {
            print(error)
            print("error")
        }
    }
    
    func saveKeychainFromLogin(userId: String, email: String, password: String) {
        do {
            if let storedPassword = try keychain.getPassword(email: email) {
                print("Contraseña encontrada en el Keychain: \(storedPassword)")
                
                if storedPassword != password {
                    print("La contraseña guardada es diferente. Actualizando...")
                    try keychain.save(uid: userId, email: email, password: password)
                } else {
                    print("La contraseña es la misma. No se necesita guardar nuevamente.")
                }
            } else {
                print("No se encontró contraseña. Guardando en el Keychain...")
                try keychain.save(uid: userId, email: email, password: password)
            }
        } catch {
            print(error)
            print(error.localizedDescription)
            print("error")
        }
    }
    
    func saveToKeychain(userId: String, email: String, password: String) {
        do {
            try keychain.save(uid: userId, email: email, password: password)
        } catch {
            if error == .duplicateEntry {
                print("duplicated aqui")
            }
            print(error)
            print("error")
        }
    }
    
    func deleteFromKeychain(userID: String) {
        do {
            let email = try keychain.getEmail(userID: userID)
            try keychain.delete(email: email)
        } catch {
            print(error)
            print("error")
        }
    }
    
    func clearKeychain() {
        do {
            try keychain.clearKeychain()
        } catch {
            print(error)
            print("keychain could not be clear completely")
        }
    }
    
    // MARK: - Create session methods
    func createToken() {
        createSession.executeCreateToken()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                    
                case .finished:
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: { [weak self] response in
                self?.openURL(response.requestToken)
            }.store(in: &cancellable)
    }
    
    func openURL(_ token: String) {
        let redirectURL = "filmify://auth-callback"
        guard let url = URL(string: "https://www.themoviedb.org/authenticate/\(token)?redirect_to=\(redirectURL)") else {
            print("Invalid URL")
            return
        }
        canOpenURL = true
        urlToOpen = url
    }
    
    func handleRedirectURL(_ url: URL) {
        let components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        if url.scheme == "filmify", url.host == "auth-callback",
           let token = components?.queryItems?.first(where: { $0.name == "request_token" })?.value,
           let approved = components?.queryItems?.first(where: { $0.name == "approved" })?.value,
           approved == "true" {
            print("Token aprobado: \(token)")
            createSessionId(token)
            canOpenURL = false // close safari after success
        } else {
            canOpenURL = false // close safari after even if fails
        }
    }
    
    func createSessionId(_ token: String) {
        createSession.executeSessionID(token: token)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                    
                case .finished:
                    break
                case .failure(let error):
                    print(error)
                }
            } receiveValue: {[weak self] response in
                print(response.sessionId)
                self?.authManager.setSessionId(sessionId: response.sessionId)
            }.store(in: &cancellable)
    }
    
    func deleteSessionId(sessionId: String) {
        createSession.executeDeleteSessionID(sessionId: sessionId)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                    
                case .finished:
                    break
                case .failure(let error):
                    print(error)
                }
            } receiveValue: { response in
                print(response.success.description)
            }.store(in: &cancellable)
    }
    
    func signInAsGuest() {
        isLoading = true
        createSession.executeSignInAsGuest()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                
                defer {
                    self?.isLoading = false
                }
                
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self?.authErrorMessage = error.localizedDescription
                    self?.showErrorAlert = true
                }
            } receiveValue: { [weak self] guestResponse in
                print(guestResponse)
                self?.setGuestModel(model: guestResponse)
            }.store(in: &cancellable)
        
    }
}

extension AuthViewModelImpl {
    @MainActor static let preview: AuthViewModelImpl = {
        var userBuilderMock = UserBuilderImpl()
        let mockAuthManager = AuthManagerImpl(userBuilder: userBuilderMock)
        
        let viewModel = AuthViewModelImpl(
            biometricAuthentication: BiometricAuthenticationImpl(),
            authManager: mockAuthManager,
            keychain: KeychainManagerImpl.shared,
            createSession: CreateSessionUseCaseImpl(repository: CreateSessionServiceImpl(networkService: NetworkServiceImpl.shared))
        )
        
        // Simulamos un usuario actual en el preview
        viewModel.currentUser = UserModel(
            id: "1",
            email: "rafael@example.com",
            password: "password123",
            fullName: "Rafael Loggiodice",
            sessionId: "")
        
        return viewModel
    }()
}

@Observable
final class AuthViewModelMock: AuthViewModel {
    
    var currentUser: UserModel? = UserModel(id: "1", email: "example@gmail.com", password: "", fullName: "Rafael Loggiodice", sessionId: "")
    
    var authManager: AuthManager = AuthManagerImpl(userBuilder: UserBuilderImpl())
    
    var authErrorMessage: String = ""
    var showErrorAlert: Bool = false
    var guestModel: GuestModel?
    var isLoading: Bool = false
    var isLoadingSignInSession: Bool = false
    
    func signIn(email: String, password: String) {}
    func signInAsGuest() {}
    func createUser() {}
    func signOut() {}
    func deleteUser() {}
}
