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
