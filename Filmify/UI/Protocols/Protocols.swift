//
//  UIProtocols.swift
//  Filmify
//
//  Created by Rafael Loggiodice on 19/12/24.
//

// This sections are the protocols to navigate to other view, they are implemented in the composition root and instanciated

import SwiftUICore

protocol CreateSectionMovies {
    @MainActor
    func createMediaSectionView(title: LocalizedStringKey, movie: [MovieResultResponse]) -> MediaSectionView
}

protocol CreateDashboard {
    @MainActor func createDashboardView() -> AnyView
}

protocol CreateSearchView {
    @MainActor func createSearchView() -> AnyView
}

protocol CreateProfileView {
    @MainActor func createProfile() -> AnyView
}

protocol CreateSectionMovie {
    @MainActor func createSectionView() -> AnyView
}

protocol CreateSignUpView {
    @MainActor func createSignUpView() -> SignUpView
    @MainActor func createPasswordView() -> PasswordView
    @MainActor func createFullNameView() -> FullNameView
}

protocol CreateSignInView {
    @MainActor func create() -> AnyView
}

protocol CreateSearchingMovie {
    @MainActor func createSearchingMovieView(title: LocalizedStringKey,
                                             movie: [MovieResultResponse]) -> SearchingMovieView
}
