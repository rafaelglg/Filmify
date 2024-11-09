//
//  ErrorManager.swift
//  RafaDBPlayer
//
//  Created by Rafael Loggiodice on 9/11/24.
//

import Foundation

enum ErrorManager: LocalizedError, Error {
    case badURL
    case badServerResponse
    case badChosenTimePeriod
    
    var errorDescription: String? {
        switch self {
            
        case .badURL:
            return "URL bad formatted"
        case .badServerResponse:
            return "The server is not working now. Try again later."
        case .badChosenTimePeriod:
            return "The time period that you choses is bad"
        }
    }
}
