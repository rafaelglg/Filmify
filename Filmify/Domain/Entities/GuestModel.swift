//
//  GuestModel.swift
//  Filmify
//
//  Created by Rafael Loggiodice on 22/12/24.
//

struct GuestModel: Codable {
    let success: Bool
    let guestSessionId: String
    let expiresAt: String
}

struct RatingResponseModel: Codable {
    let success: Bool
    let statusCode: Int
    let statusMessage: String
}
