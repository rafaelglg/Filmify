//
//  PersonDetailModel.swift
//  RafaDBPlayer
//
//  Created by Rafael Loggiodice on 20/11/24.
//

import Foundation

struct PersonDetailModel: Decodable, Identifiable {
    let alsoKnownAs: [String]
    let biography: String
    let birthday: String?
    let deathday: String?
    let gender: Int
    let homepage: String?
    let id: Int
    let imdbId: String
    let knownForDepartment: String
    let name: String
    let placeOfBirth: String?
    let popularity: Double
    
    var homePageURL: URL {
        guard let url = URL(string: homePageFormatted) else {
            return URL(filePath: "")
        }
        return url
    }
    
    var hasWebsite: Bool {
        homepage != nil
    }
    
    var homePageFormatted: String {
        homepage ?? ""
    }
    
    var dateOfBirthFormatted: String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"
        guard let date = inputFormatter.date(from: birthday ?? "no birthday") else {
            return "no date"
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long // To have the date ej: 21 November 2024
        dateFormatter.timeStyle = .none // Without the hour
        dateFormatter.locale = .current
        return dateFormatter.string(from: date)
    }
    
    func isDead() -> Bool {
        deathday == nil ? false : true
    }
    
    var age: Int {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"
        guard let date = inputFormatter.date(from: birthday ?? "") else {
            return 0
        }
        let calendar = Calendar.current
        let age = calendar.dateComponents([.year], from: date, to: .now)
        return age.year ?? 0
    }
    
    var deathDayFormatted: String {
        let inputFormatted = DateFormatter()
        inputFormatted.dateFormat = "yyyy-MM-dd"
        
        guard let date = inputFormatted.date(from: deathday ?? "") else {
            return "no death"
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        return dateFormatter.string(from: date)
    }
}
