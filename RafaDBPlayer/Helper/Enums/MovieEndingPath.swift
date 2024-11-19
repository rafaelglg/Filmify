//
//  MovieEndingPath.swift
//  RafaDBPlayer
//
//  Created by Rafael Loggiodice on 7/11/24.
//

import Foundation

enum MovieEndingPath: Equatable {
    case nowPlaying
    case upcoming
    case topRated
    case day
    case week
    case id(String)
    case castMembers
    case reviews

    var isTrendingAllow: Bool {
        switch self {
        case .day, .week:
            return true
        default:
            return false
        }
    }
    
    var pathValue: String {
        switch self {
        case .nowPlaying: return "now_playing"
        case .upcoming: return "upcoming"
        case .topRated: return "top_rated"
        case .day: return "day"
        case .week: return "week"
        case .id(let id): return id
        case .castMembers: return "credits"
        case .reviews: return "reviews"
        }
    }
}
