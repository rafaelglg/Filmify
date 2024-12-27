//
//  Constants.swift
//  Filmify
//
//  Created by Rafael Loggiodice on 6/11/24.
//

import Foundation

struct Constants {
    static let movieGeneralPath: String = "https://api.themoviedb.org/3/movie/"
    static let imageURL: String = "https://image.tmdb.org/t/p/w500"
    static let trendingMovies: String = "https://api.themoviedb.org/3/trending/movie/"
    static let personDetail: String = "https://api.themoviedb.org/3/person/"
    static let guestSessionPath: String = "https://api.themoviedb.org/3/authentication/guest_session/new"
    static let createTokenPath: String = "https://api.themoviedb.org/3/authentication/token/new"
    static let authenticateWithSession: String = "https://www.themoviedb.org/authenticate/"
    static let createNewSessionPath: String = "https://api.themoviedb.org/3/authentication/session/new"
    static let deleteSessionIdPath: String = "https://api.themoviedb.org/3/authentication/session"
}
