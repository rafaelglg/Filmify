//
//  MovieDetails.swift
//  RafaDBPlayer
//
//  Created by Rafael Loggiodice on 9/11/24.
//

import Foundation

struct MovieDetails: Decodable, Identifiable {
    let adult: Bool
    let backdropPath: String?
    let budget: Int
    let genres: [Genres]?
    let homepage: String
    let id: Int
    let imdbId: String?
    let originCountry: [String]
    let originalLanguage: String
    let posterPath: String?
    let productionCompanies: [ProductionCompanies]
    let productionCountries: [ProductionCountries]
    let runtime: Int
    let revenue: Int
    let spokenLanguages: [SpokenLanguages]
    let status: String
    let tagline: String
    let video: Bool
    let videos: VideoResponse
    
    var revenueFormatted: String {
        if revenue == 0 {
            return "no info yet"
        }
        return revenue.formatted(.number)
    }
    
    var genresFormatted: String {
        
        if let genres = genres, genres.isEmpty {
            return "No genre info available"
        } else {
            return genres?
                .map { $0.name }
                .joined(separator: ", ") ?? "" // to have the names outside of the array and separated by ", "
        }
    }
}

struct VideoResponse: Decodable {
    let results: [ResultVideoMovies]
}

struct ResultVideoMovies: Decodable, Identifiable {
    let iso6391: String
    let iso31661: String
    let name: String
    let key: String
    let site: String
    let size: Int
    let type: String
    let official: Bool
    let publishedAt: String
    let id: String
}

struct Genres: Decodable, Identifiable, Hashable {
    let id: Int
    let name: String
}

struct ProductionCompanies: Decodable, Identifiable, Hashable {
    let id: Int
    let logoPath: String?
    let name: String
    let originCountry: String
    
    var logoURL: URL? {
        guard let url = URL(string: Constants.imageURL) else {
            return nil
        }
        
        return url.appending(path: logoPath ?? "")
    }
}

struct ProductionCountries: Decodable, Hashable {
    let iso31661: String
    let name: String
}

struct SpokenLanguages: Decodable, Identifiable, Hashable {
    var id = UUID()
    let englishName: String
    let iso6391: String
    let name: String
    
    var countryCodeName: String {
        switch iso6391 {
        case "en":
            return "US"
        case "ja":
            return "JP"
        case "he":
            return "IL"
        case "xx":
            return ""
        case "ko":
            return "KR"
        case "hi":
            return "IN"
        case "hy":
            return "AM"
        case "cs":
            return "CZ"
        case "ka":
            return "GE"
        default:
            return iso6391.uppercased()
        }
    }
    
    func countryFlag(countryCode: String) -> String {
        let base = 127397
        var tempScalarView = String.UnicodeScalarView()
        for country in countryCode.utf16 {
            if let scalar = UnicodeScalar(base + Int(country)) {
                tempScalarView.append(scalar)
            }
        }
        return String(tempScalarView)
    }
    
    enum CodingKeys: String, CodingKey {
        case englishName, iso6391, name
    }
}
