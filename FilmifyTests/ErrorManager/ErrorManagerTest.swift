//
//  ErrorManagerTest.swift
//  Filmify
//
//  Created by Rafael Loggiodice on 7/12/24.
//

import Testing
@testable import RafaDBPlayer

@Suite("Error Manager")
struct ErrorManagerTest {
    
    @Test("Error descriptions")
    func errorDescriptions() {
        let cases: [(ErrorManager, String)] = [
            (.badURL, "URL bad formatted"),
            (.badServerResponse, "The server is not working now. Try again later."),
            (.badChosenTimePeriod, "The time period that you choses is bad")
        ]
        
        for (errorCase, expectedDescription) in cases {
            #expect(errorCase.errorDescription == expectedDescription, "The error description for \(errorCase) is incorrect.")
        }
    }
}
