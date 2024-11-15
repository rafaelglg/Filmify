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

extension MovieReviewViewModel {
    @MainActor static let preview: MovieReviewViewModel = {
        var viewModel = MovieReviewViewModel(movieReviewUsesCase: MovieReviewUsesCaseImpl() )
        viewModel.movieReviews = [.preview]
        return viewModel
    }()
}

extension MovieReviewResponse {
    static let preview = MovieReviewResponse(author: "Rafaelglg", authorDetails: authorDetail, content: "Good stuff", createdAt: "2024-10-25T18:25:18.286Z", id: "671be28e9ff681d9e0a410bd", updatedAt: "2024-10-25T18:25:18.374Z", url: "https://www.themoviedb.org/review/671be28e9ff681d9e0a410bd")
    
    static let authorDetail = AuthorDetail(name: "Rafael", username: "rafaelglg", avatarPath: "/mwR7rFHoDcobAx1i61I3skzMW3U.jpg", rating: 7)
}

extension Data {
    var html2AttributedString: NSAttributedString? {
        do {
            return try NSAttributedString(data: self, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            print("error:", error)
            return  nil
        }
    }
    var html2String: String { html2AttributedString?.string ?? "" }
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
    
    var html2AttributedString: NSAttributedString? {
        Data(utf8).html2AttributedString
    }
    var html2String: String {
        html2AttributedString?.string ?? ""
    }
}
