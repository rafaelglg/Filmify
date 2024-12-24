//
//  Extensions.swift
//  Filmify
//
//  Created by Rafael Loggiodice on 6/11/24.
//

import Foundation
import SwiftUI

extension MovieResultResponse {
    
    // swiftlint:disable:next line_length
    static let preview: MovieResultResponse = MovieResultResponse(id: 1, adult: false, backdropPath: "/9oYdz5gDoIl8h67e3ccv3OHtmm2.jpg", originalLanguage: "ES", originalTitle: "Batman The Last Dance in the year of hero", overview: "batman es un superheroe muy bueno que ha batallado muchas veces en los saltamontes del callar del bueno. Esto ha dado paso para que los minihuertos del cellar puedan irse al pasto verde del descanso", popularity: 8.99, posterPath: "/lqoMzCcZYEFK729d6qzt349fB4o.jpg", releaseDate: "2024-09-10", title: "Batman title", video: false, voteAverage: 8.9, voteCount: 9)
}

extension MovieDetails {
    // swiftlint:disable:next line_length
    static let preview = MovieDetails(adult: false, backdropPath: "vq340s8DxA5Q209FT8PHA6CXYOx.jpg", budget: 120000000, genres: genres, homepage: "https://venom.movie", id: 912649, imdbId: "tt16366836", originCountry: originCountry, originalLanguage: "en", posterPath: "aosm8NMQ3UyoBVpSxyimorCQykC.jpg", productionCompanies: productionCompanies, productionCountries: productionCountries, runtime: 109, revenue: 150000, spokenLanguages: spokenLanguages, status: "Released", tagline: "'Til death do they part.", video: false, videos: videos)
    
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
    
    static let videos = VideoResponse(results: results)
    
    static let results = [
        ResultVideoMovies(iso6391: "En", iso31661: "en", name: "movie", key: "key", site: "youtube", size: 1080, type: "video", official: true, publishedAt: "", id: "123"),
        ResultVideoMovies(iso6391: "En", iso31661: "en", name: "movie", key: "key", site: "youtube", size: 1080, type: "video", official: true, publishedAt: "", id: "123")
    ]
}

extension MovieReviewViewModelImpl {
    @MainActor static let preview: MovieReviewViewModelImpl = {
        var viewModel = MovieReviewViewModelImpl(movieReviewUsesCase: MovieReviewUsesCaseImpl(repository: MovieReviewServiceImpl(productService: ReviewProductServiceImpl(networkService: NetworkService.shared))))
        viewModel.movieReviews = [.preview]
        return viewModel
    }()
}

extension MovieReviewResponse {
    static let preview = MovieReviewResponse(author: "Rafaelglg", authorDetails: authorDetail, content: "Good stuff", createdAt: "2024-10-25T18:25:18.286Z", id: "671be28e9ff681d9e0a410bd", updatedAt: "2024-10-25T18:25:18.374Z", url: "https://www.themoviedb.org/review/671be28e9ff681d9e0a410bd")
    
    static let authorDetail = AuthorDetail(name: "Rafael", username: "rafaelglg", avatarPath: "/mwR7rFHoDcobAx1i61I3skzMW3U.jpg", rating: 7)
}

extension CastModel {
    static let preview = CastModel(id: 1, cast: CastResponseModel.preview, crew: CrewResponseModel.preview)
}

extension CastResponseModel {
    static let preview = [
        // swiftlint:disable:next line_length
        CastResponseModel(adult: false, gender: 11, id: 12, knownForDepartment: "Acting", name: "Rafa", originalName: "Rafael", popularity: 20.00, profilePath: "/gVICVa6IypG6BMLsPhscrYICptn.jpg", castId: 10, character: "Shelter Official", creditId: "", order: 1),
        CastResponseModel(adult: false, gender: 11, id: 12, knownForDepartment: "", name: "Rafa", originalName: "Rafael", popularity: 20.00, profilePath: "/fGVOikpvivopeATDy6ZzLdKYXDu.jpg", castId: 10, character: "", creditId: "", order: 1),
        CastResponseModel(adult: false, gender: 11, id: 12, knownForDepartment: "", name: "Rafa", originalName: "Rafael", popularity: 20.00, profilePath: "", castId: 10, character: "", creditId: "", order: 1),
        CastResponseModel(adult: false, gender: 11, id: 12, knownForDepartment: "", name: "Rafa", originalName: "Rafael", popularity: 20.00, profilePath: "", castId: 10, character: "", creditId: "", order: 1)
    ]
}

extension CrewResponseModel {
    static let preview = [
        CrewResponseModel(adult: false, gender: 0, id: 12, knownForDepartment: "Science", name: "Jose", originalName: "Joseph", popularity: 19.22, profilePath: "/j9qXEqOsZENCqni8WzGH6pXginJ.jpg", creditId: "", department: "", job: "Science Fiction"),
        CrewResponseModel(adult: false, gender: 0, id: 12, knownForDepartment: "Science", name: "Jose", originalName: "Joseph", popularity: 19.22, profilePath: "", creditId: "", department: "Visual Effects", job: "VFX Artist"),
        CrewResponseModel(adult: false, gender: 0, id: 12, knownForDepartment: "Science", name: "Jose", originalName: "Joseph", popularity: 19.22, profilePath: "", creditId: "", department: "", job: "Science Fiction")
    ]
}

extension PersonDetailModel {
    // swiftlint:disable:next line_length
    static let preview = PersonDetailModel(alsoKnownAs: ["마가렛 퀄리", "マーガレット・クアリー", "Sarah Margaret Qualley", "Маргарет Кволлі"], biography: "Sarah Margaret Qualley (born October 23, 1994). Edward Thomas Hardy CBE (born 15 September 1977) is an English actor, producer, writer and former model. After studying acting at the Drama Centre London, he made his film debut in Ridley Scott\'s Black Hawk Down (2001). He has since been nominated for the Academy Award for Best Supporting Actor", birthday: "", deathday: "", gender: 1, homepage: "", id: 1, imdbId: "", knownForDepartment: "Acting", name: "Margaret", placeOfBirth: "", popularity: 1.1)
}

extension UserModel {
    static let preview = UserModel(id: "1", email: "rafaglg9@gmail.com", password: "aA@123456", fullName: "Rafael Loggiodice")
}

extension Data {
    var html2AttributedString: NSAttributedString? {
        do {
            return try NSAttributedString(data: self, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
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

extension Array {
    /// This extension is because i had a error in the console saying that i have repetead ID in the models, so this help me to remove the repetitive ID in the foreach
    func removingDuplicates<T: Hashable>(by keyPath: KeyPath<Element, T>) -> [Element] {
        var seen = Set<T>()
        return filter { seen.insert($0[keyPath: keyPath]).inserted }
    }
}

extension View {
    func customTabBarAppearance(forSelectedItem: UIColor? = nil, forUnselectedItem unselectedColor: UIColor) -> some View {
        self.onAppear {
            let appearance = UITabBar.appearance()
            appearance.unselectedItemTintColor = unselectedColor
            appearance.tintColor = forSelectedItem
        }
    }
}

extension PreviewTrait where T == Preview.ViewTraits {
    static let environments: Self = .modifier(EnvironmentTraits())
}

struct EnvironmentTraits: PreviewModifier {
    
    func body(content: Content, context: Void) -> some View {
        @Previewable @State var network = NetworkMonitorImpl()
        @Previewable @State var movieVM = MovieViewModel(movieUsesCase: MovieUsesCasesImpl(repository: MovieProductServiceImpl(productService: NetworkService.shared)))
        content
            .environment(movieVM)
            .environment(network)
    }
}
