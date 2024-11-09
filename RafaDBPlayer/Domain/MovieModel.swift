//
//  MovieModel.swift
//  RafaDBPlayer
//
//  Created by Rafael Loggiodice on 6/11/24.
//

import Foundation
import SwiftUI

struct MovieModel: Decodable, Identifiable, Hashable {
    var id = UUID()
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
    let backdropPath: String
    let originalLanguage: String
    let originalTitle: String
    let overview: String
    let popularity: Double
    let posterPath: String
    let releaseDate: String
    let title: String
    let video: Bool
    let voteAverage: Float
    let voteCount: Int
    
    var backdropURLImage: URL {
        guard let url = URL(string: Constants.imageURL) else {return URL(filePath: "URL ERROR")}
        return url.appending(path: backdropPath)
    }
    
    var posterURLImage: URL {
        guard let url = URL(string: Constants.imageURL) else {return URL(filePath: "URL ERROR")}
        return url.appending(path: posterPath)
    }
}

/*
 
 "page": 1,
   "results": [
     {
       "adult": false,
       "backdrop_path": "/gMQibswELoKmB60imE7WFMlCuqY.jpg",
       "genre_ids": [
         27,
         53,
         9648
       ],
       "id": 1034541,
       "original_language": "en",
       "original_title": "Terrifier 3",
       "overview": "Five years after surviving Art the Clown's Halloween massacre, Sienna and Jonathan are still struggling to rebuild their shattered lives. As the holiday season approaches, they try to embrace the Christmas spirit and leave the horrors of the past behind. But just when they think they're safe, Art returns, determined to turn their holiday cheer into a new nightmare. The festive season quickly unravels as Art unleashes his twisted brand of terror, proving that no holiday is safe.",
       "popularity": 5444.687,
       "poster_path": "/63xYQj1BwRFielxsBDXvHIJyXVm.jpg",
       "release_date": "2024-10-09",
       "title": "Terrifier 3",
       "video": false,
       "vote_average": 7.3,
       "vote_count": 617
     },
 
 */
