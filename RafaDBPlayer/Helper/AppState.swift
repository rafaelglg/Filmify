//
//  AppState.swift
//  RafaDBPlayer
//
//  Created by Rafael Loggiodice on 16/12/24.
//
import Foundation

protocol AppState {
    var currentState: SignUpState? { get }
    var navigationPath: [SignUpState] { get }
    
    func changeSignUpState(newValue: SignUpState?)
    func pushTo(_ newState: SignUpState)
    func popToRoot()
    func resetNavigationPath()
}

@Observable
final class AppStateImpl: AppState {
    
    var currentState: SignUpState?
    var navigationPath: [SignUpState] = []
    
    func changeSignUpState(newValue: SignUpState?) {
        currentState = newValue
    }
    
    func pushTo(_ newState: SignUpState) {
        navigationPath.append(newState)
    }

    func popToRoot() {
        currentState = nil
    }
    
    func resetNavigationPath() {
        navigationPath = []
    }
}
