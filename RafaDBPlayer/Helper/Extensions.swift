//
//  Extensions.swift
//  RafaDBPlayer
//
//  Created by Rafael Loggiodice on 6/11/24.
//

import Foundation

extension MovieResultResponse {
    
    // swiftlint:disable:next line_length
    static let preview: MovieResultResponse = MovieResultResponse(id: 1, adult: false, backdropPath: "/9oYdz5gDoIl8h67e3ccv3OHtmm2.jpg", originalLanguage: "ES", originalTitle: "Batman The Last Dance in the year of hero", overview: "batman es un superheroe muy bueno", popularity: 8.99, posterPath: "/lqoMzCcZYEFK729d6qzt349fB4o.jpg", releaseDate: "2024-09-10", title: "Batman title", video: false, voteAverage: 8.9, voteCount: 9)
}

extension MovieDetailModel {
    // swiftlint:disable:next line_length
    static let detailPreview: MovieDetailModel = MovieDetailModel(adult: false, backdropPath: "vq340s8DxA5Q209FT8PHA6CXYOx.jpg", budget: 120000000, genres: genres, homepage: "https://venom.movie", id: 912649, imdbId: "tt16366836", originCountry: originCountry, originalLanguage: "en", posterPath: "aosm8NMQ3UyoBVpSxyimorCQykC.jpg", productionCompanies: productionCompanies, productionCountries: productionCountries, runtime: 109, revenue: 150000, spokenLanguages: spokenLanguages, status: "Released", tagline: "'Til death do they part.", video: false)
    
    static let genres: [Genres] = [
        Genres(id: 878, name: "Science Fiction"),
        Genres(id: 28, name: "Action"),
        Genres(id: 12, name: "Adventure")
    ]
    static let originCountry: [String] = ["US"]

    static let productionCompanies: [ProductionCompanies] = [
        ProductionCompanies(id: 5, logoPath: "/wwemzKWzjKYJFfCeiB57q3r4Bcm.png", name: "Columbia Pictures", originCountry: "US"),
        ProductionCompanies(id: 84041, logoPath: "/nw4kyc29QRpNtFbdsBHkRSFavvt.png", name: "Pascal Pictures", originCountry: "US"),
        ProductionCompanies(id: 321, logoPath: nil, name: "Buenas Pictures", originCountry: "US")
    ]
    
    static let productionCountries: [ProductionCountries] = [
        ProductionCountries(iso31661: "US", name: "United States of America")
    ]
    
    static let spokenLanguages: [SpokenLanguages] = [
        SpokenLanguages(englishName: "English", iso6391: "en", name: "English")
    ]
}

extension String {
    
    func toDate(withFormat format: String = "yyyy-MM-dd") -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let date = dateFormatter.date(from: self)
        return date
    }
    
    func dateFormatter() -> String {
        guard let date = self.toDate() else { return "No date" }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy"
        dateFormatter.locale = .current
        return dateFormatter.string(from: date)
    }
    
    func toYear() -> String {
        guard let date = self.toDate() else { return "No date" }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        return dateFormatter.string(from: date)
    }
}
