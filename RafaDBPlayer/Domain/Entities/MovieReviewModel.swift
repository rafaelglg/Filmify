//
//  MovieReviewModel.swift
//  RafaDBPlayer
//
//  Created by Rafael Loggiodice on 11/11/24.
//

import Foundation

struct MovieReviewModel: Decodable, Identifiable, Hashable {
    let id: Int
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
