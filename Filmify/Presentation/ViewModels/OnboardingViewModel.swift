//
//  OnboardingViewModelImpl.swift
//  Filmify
//
//  Created by Rafael Loggiodice on 10/12/24.
//

import Foundation

protocol OnboardingViewModel {
    var welcoming: [String] { get }
    var showButton: Bool { get set }
    var goToDashboard: Bool { get set }
    var goToSignIn: Bool { get set }
    func isBoldCharacter(line: String, charIndex: Int) -> Bool
}

@Observable
final class OnboardingViewModelImpl: OnboardingViewModel {
    
    var showButton: Bool = false
    var goToSignIn: Bool = false
    var goToDashboard: Bool = false
    let welcoming = [
        "Welcome to",
        "Filmify"
    ]
    
    func isBoldCharacter(line: String, charIndex: Int) -> Bool {
        let target = "Filmify"
        guard let range = line.range(of: target) else { return false }
        let targetIndices = line.distance(from: line.startIndex, to: range.lowerBound)..<line.distance(from: line.startIndex, to: range.upperBound)
        return targetIndices.contains(charIndex)
    }
}
