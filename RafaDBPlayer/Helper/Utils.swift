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
}
