//
//  MovieReviewModel.swift
//  Filmify
//
//  Created by Rafael Loggiodice on 11/11/24.
//

import Foundation

struct MovieReviewModel: Decodable, Hashable {
    let page: Int
    let results: [MovieReviewResponse]
}

struct MovieReviewResponse: Decodable, Identifiable, Hashable {
    let author: String
    let authorDetails: AuthorDetail
    let content: String
    let createdAt: String
    let id: String
    let updatedAt: String
    let url: String
    
    var creationDateFormatted: String {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        guard let date = isoFormatter.date(from: createdAt) else {
            return ""
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy MMM d"
        dateFormatter.locale = .current
        return dateFormatter.string(from: date)
    }
    
    var creationDate: Date { // to have the date sort option.
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return isoFormatter.date(from: createdAt) ?? Date()
    }
}

struct AuthorDetail: Decodable, Hashable {
    let name: String
    let username: String
    let avatarPath: String?
    let rating: Int?
    
    var avatarPathURL: URL {
        guard let url = URL(string: Constants.imageURL) else {
            return URL(filePath: "bad url")
        }
        return url.appending(path: avatarPath ?? "no image")
    }
}
