//
//  MovieModel.swift
//  RafaDBPlayer
//
//  Created by Rafael Loggiodice on 6/11/24.
//

import Foundation
import SwiftUI

struct MovieModel: Decodable, Hashable {
    let page: Int
    let results: [MovieResultResponse]
    
    enum CodingKeys: String, CodingKey {
        case page
        case results
    }
}

struct MovieResultResponse: Decodable, Identifiable, Hashable {
    let id: Int
    let adult: Bool
    let backdropPath: String?
    let originalLanguage: String
    let originalTitle: String
    let overview: String?
    let popularity: Double
    let posterPath: String?
    let releaseDate: String
    let title: String
    let video: Bool
    let voteAverage: Float
    let voteCount: Int
    
    var backdropURLImage: URL {
        guard let url = URL(string: Constants.imageURL) else {return URL(filePath: "URL ERROR")}
        return url.appending(path: backdropPath ?? "no image")
    }
    
    var posterURLImage: URL {
        guard let url = URL(string: Constants.imageURL) else {return URL(filePath: "URL ERROR")}
        return url.appending(path: posterPath ?? "no image")
    }
}
