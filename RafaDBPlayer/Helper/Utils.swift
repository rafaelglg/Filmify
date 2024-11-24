//
//  Utils.swift
//  RafaDBPlayer
//
//  Created by Rafael Loggiodice on 6/11/24.
//

import Foundation

struct Utils {
    
    static let jsonDecoder: JSONDecoder = {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        
        return jsonDecoder
    }()
    
    static func movieURL(basePath: String, endingPath: MovieEndingPath ) -> String {
        return basePath + endingPath.pathValue
    }
    
    static func movieURL(baseURL: String, id: MovieEndingPath, endingPath: MovieEndingPath) -> String {
        return baseURL + id.pathValue + (endingPath != .none ?  "/" + endingPath.pathValue : "")
    }
    
    static func movieAppendURL(id: MovieEndingPath, endingPath: [MovieEndingPath]) -> String {
        
        let appendEndingPath = endingPath.map {$0.pathValue}.joined(separator: ",")
        
        return "https://api.themoviedb.org/3/movie/\(id.pathValue)?api_key=\(ApiKey.movieApi)&append_to_response=\(appendEndingPath)"
    }
}
