//
//  AuthManagerImpl.swift
//  Filmify
//
//  Created by Rafael Loggiodice on 21/12/24.
//

import Firebase
import FirebaseAuth
import Combine
import SwiftUICore

protocol AuthManager {
    var userSession: User? { get set }
    var userBuilder: UserBuilder? { get }
    
    func setEmail(withEmail email: String)
    func setPassword(password: String)
    func setFullName(fullName: String)
    
    func createUser() -> Future<UserModel, FirebaseAuthError>
    func signIn(email: String, password: String) -> Future<UserModel, FirebaseAuthError>
    func signOut() -> Future<Void, FirebaseAuthError>
    func deleteUser() -> Future< User, FirebaseAuthError>
}

@Observable
final class AuthManagerImpl: AuthManager {
    var userSession: User?
    var userBuilder: UserBuilder?
    
    init(userBuilder: UserBuilder) {
        self.userBuilder = userBuilder
        self.userSession = Auth.auth().currentUser
    }
    
    func createUser() -> Future<UserModel, FirebaseAuthError> {
        
        return Future { [weak self] promise in
            
            guard let userBuilder = self?.userBuilder else {
                print("Error: Missing data to create user")
                promise(.failure(FirebaseAuthError.userBuilderNil))
                return
            }
            
            Auth.auth().createUser(withEmail: userBuilder.email, password: userBuilder.password) { [weak self] createdUser, error in
                
                if let error {
                    if let authError = AuthErrorCode(rawValue: (error as NSError).code) {
                        promise(.failure(FirebaseAuthError.mapAuthError(authError)))
                    } else {
                        promise(.failure(FirebaseAuthError.unknownError((error as NSError).code)))
                    }
                }
                
                guard let createdUser else {
                    return promise(.failure(FirebaseAuthError.emailAlreadyInUse))
                }
                
                guard let userModel = self?.userBuilder?.build(user: createdUser) else {
                    print("Error: Missing data to create user")
                    return
                }
                
                withAnimation {
                    self?.userSession = createdUser.user
                }
                promise(.success(userModel))
            }
        }
    }
    
    func signIn(email: String, password: String) -> Future<UserModel, FirebaseAuthError> {
        
        return Future { [weak self] promise in
            
            Auth.auth().signIn(withEmail: email, password: password) { [weak self] createdUser, error in
                
                if let error {
                    if let authError = AuthErrorCode(rawValue: (error as NSError).code) {
                        promise(.failure(FirebaseAuthError.mapAuthError(authError)))
                    } else {
                        promise(.failure(FirebaseAuthError.unknownError((error as NSError).code)))
                    }
                }
                
                guard let createdUser else {
                    return promise(.failure(FirebaseAuthError.emailAlreadyInUse))
                }
                
                guard let userModel = self?.userBuilder?.build(user: createdUser) else {
                    print("Error: Missing data to create user")
                    return
                }
                
                withAnimation {
                    self?.userSession = createdUser.user
                }
                promise(.success(userModel))
            }
        }
    }
    
    func signOut() -> Future<Void, FirebaseAuthError> {
        
        return Future { [weak self] promise in
            do {
                self?.userSession = nil
                self?.userBuilder?.reset()
                try Auth.auth().signOut()
                promise(.success(()))
            } catch {
                promise(.failure(.signOutError))
            }
        }
    }
    
    func deleteUser() -> Future<User, FirebaseAuthError> {
        return Future { promise in
            guard let user = Auth.auth().currentUser else {
                promise(.failure(.deleteUserError))
                return
            }
            
            promise(.success(user))
            self.userSession = nil
            self.userBuilder?.reset()
            user.delete()
        }
    }
}

extension AuthManagerImpl {
    // MARK: Builder methods
    func setEmail(withEmail email: String) {
        userBuilder?.setEmail(email)
    }
    
    func setPassword(password: String) {
        userBuilder?.setPassword(password)
    }
    
    func setFullName(fullName: String) {
        userBuilder?.setFullName(fullName)
    }
}

/// Is used for firebase error handling
enum FirebaseAuthError: LocalizedError, Error {
    case emailAlreadyInUse
    case invalidEmail
    case invalidCredential
    case wrongPassword
    case networkError
    case weakPassword
    case unknownError(Int)
    case userBuilderNil
    case signOutError
    case deleteUserError
    case sessionExpired
    
    init(errorCode: Int) {
        if let authError = AuthErrorCode(rawValue: errorCode) {
            self = FirebaseAuthError.mapAuthError(authError)
        } else {
            self = .unknownError(errorCode)
        }
    }
    
    static func mapAuthError(_ error: AuthErrorCode ) -> FirebaseAuthError {
        switch error {
        case .emailAlreadyInUse:
            return .emailAlreadyInUse
        case .invalidEmail:
            return .invalidEmail
        case .wrongPassword:
            return .wrongPassword
        case .networkError:
            return .networkError
        case .nullUser:
            return .userBuilderNil
        case .sessionExpired:
            return .sessionExpired
        case .invalidCredential:
            return .invalidCredential
        default:
            return .unknownError(error.rawValue)
        }
    }
    
    var errorDescription: String? {
        switch self {
        case .invalidEmail:
            return "Invalid email, please ensure to add a correct email"
        case .invalidCredential:
            return "Wrong email or password, please check again"
        case .wrongPassword:
            return "Wrong password, please check again"
        case .networkError:
            return "No internet connection, please find internet connection"
        case .weakPassword:
            return "Weak password, please ensure to have a minimun of 6 characters"
        case .unknownError:
            return "Unknown error"
        case .emailAlreadyInUse:
            return "The email address is already in use by another account. please use a different email"
        case .userBuilderNil:
            return "The user was not built correctly"
        case .signOutError:
            return "Some error occur signing out, try again."
        case .deleteUserError:
            return "Error deleting user, try again later"
        case .sessionExpired:
            return "Session expired, try again authentication methods"
        }
    }
}
