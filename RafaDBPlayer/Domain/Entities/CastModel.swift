//
//  CastModel.swift
//  RafaDBPlayer
//
//  Created by Rafael Loggiodice on 17/11/24.
//

import Foundation

struct CastModel: Decodable, Identifiable, Hashable {
    let id: Int
    let cast: [CastResponseModel]
    let crew: [CrewResponseModel]
}

struct CastResponseModel: Decodable, Identifiable, Hashable {
    let adult: Bool
    let gender: Int
    let id: Int
    let knownForDepartment: String
    let name: String
    let originalName: String
    let popularity: Double
    let profilePath: String?
    let castId: Int
    let character: String
    let creditId: String
    let order: Int
    
    var imageURL: URL {
        guard let url = URL(string: Constants.imageURL) else {
            return URL(filePath: "no image")
        }
        return url.appending(path: profilePath ?? "")
    }
}

struct CrewResponseModel: Decodable, Identifiable, Hashable {
    let adult: Bool
    let gender: Int
    let id: Int
    let knownForDepartment: String
    let name: String
    let originalName: String
    let popularity: Double
    let profilePath: String?
    let creditId: String
    let department: String
    let job: String
    
    var profileImageURL: URL {
        guard let url = URL(string: Constants.imageURL) else {
            return URL(filePath: "bad url")
        }
        return url.appending(path: profilePath ?? "")
    }
}
