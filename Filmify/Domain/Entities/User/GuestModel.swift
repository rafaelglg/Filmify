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

struct TokenResponseModel: Codable {
    let success: Bool
    let expiresAt: String
    let requestToken: String
}

struct SessionIdResponseModel: Codable {
    let success: Bool
    let sessionId: String
}

struct DeleteSessionIdResponseModel: Codable {
    let success: Bool
}
