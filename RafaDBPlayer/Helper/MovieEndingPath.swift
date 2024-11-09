//
//  MovieEndingPath.swift
//  RafaDBPlayer
//
//  Created by Rafael Loggiodice on 7/11/24.
//

import Foundation

enum MovieEndingPath: String {
    case nowPlaying = "now_playing"
    case upcoming
    case topRated = "top_rated"
    case day
    case week
    
    var isTrendingAllow: Bool {
        return self == .day || self == .week
    }
}
