//
//  OnboardingViewModelImpl.swift
//  RafaDBPlayer
//
//  Created by Rafael Loggiodice on 10/12/24.
//

import Foundation

protocol OnboardingViewModel {
    var welcoming: [String] { get }
    var showButton: Bool { get set }
    var goToDashboard: Bool { get set }
    func isBoldCharacter(line: String, charIndex: Int) -> Bool
}

@Observable
final class OnboardingViewModelImpl: OnboardingViewModel {
    
    var showButton: Bool = false
    var goToDashboard: Bool = false
    let welcoming = [
        "Welcome to",
        "Rafa DB Player"
    ]
    
    func isBoldCharacter(line: String, charIndex: Int) -> Bool {
        let target = "DB Player"
        guard let range = line.range(of: target) else { return false }
        let targetIndices = line.distance(from: line.startIndex, to: range.lowerBound)..<line.distance(from: line.startIndex, to: range.upperBound)
        return targetIndices.contains(charIndex)
    }
}
