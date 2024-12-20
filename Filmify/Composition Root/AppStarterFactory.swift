//
//  AppStarterFactory.swift
//  Filmify
//
//  Created by Rafael Loggiodice on 18/12/24.
//

import Foundation
import SwiftUICore

@MainActor
final class AppStarterFactory {
    
    static private let signInFactory = SignInFactory()
    static private let searchViewFactory = SearchViewFactory()
    static private let dashboardFactory = DashboardFactory()
    static private let createProfileView = ProfileViewFactory()
    
    @ViewBuilder
    static func startApp(hasCompletedOnboarding: Bool) -> some View {
        if !hasCompletedOnboarding {
            createOnboarding()
        } else if EnvironmentFactory.authViewModel.currentUser == nil {
            signInFactory.create()
        } else {
            createTabBarView()
                .transition(.blurReplace())
            
        }
    }
    
    static func createOnboarding() -> some View {
        return OnBoarding(onboardingVM: createOnboardingViewModel(),
                          createSignInView: signInFactory)
        .environment(EnvironmentFactory.authViewModel)
        .environment(EnvironmentFactory.appState)
    }
    
    private static func createTabBarView() -> some View {
        return TabBarView(movieVM: createMovieVieModel(),
                          network: EnvironmentFactory.network,
                          createDashboard: dashboardFactory,
                          createSearchView: searchViewFactory,
                          createProfileView: createProfileView)
        .environment(EnvironmentFactory.authViewModel)
    }
    
    private static func createOnboardingViewModel() -> OnboardingViewModel {
        OnboardingViewModelImpl()
    }
    
    private static func createMovieVieModel() -> MovieViewModel {
        MovieViewModel(movieUsesCase: createMovieUseCase())
    }
    
    static func createMovieUseCase() -> MovieUsesCases {
        MovieUsesCasesImpl(repository: createMovieRepository())
    }
    
    private static func createMovieRepository() -> MovieProductService {
        MovieProductServiceImpl(productService: createNetworkService())
    }
    
    private static func createNetworkService() -> NetworkServiceProtocol {
        NetworkService.shared
    }
}

final class MediaSectionFactory: CreateSectionMovies {
    
    func createMediaSectionView(title: LocalizedStringKey, movie: [MovieResultResponse]) -> MediaSectionView {
        return MediaSectionView(movieReviewVM: MovieViewModelFactory.createMovieReviewViewModel(),
                                castMemberVM: MovieViewModelFactory.createMovieCastMembersViewModel(),
                                title: title,
                                movie: movie)
    }
}

final class SectionMovieFactory: CreateSectionMovie {
    
    private let mediaSectionFactory = MediaSectionFactory()
    
    @MainActor func createSectionView() -> AnyView {
        return AnyView(SectionMovies(mediaSectionFactory: mediaSectionFactory)
            .environment(EnvironmentFactory.movieVM))
    }
}

final class ProfileViewFactory: CreateProfileView {
    
    @MainActor
    func createProfile() -> AnyView {
        return AnyView(ProfileView()
            .environment(EnvironmentFactory.authViewModel))
    }
}

final class SignInFactory: CreateSignInView {
    
    @MainActor func create() -> AnyView {
        AnyView(SignInView(signInVM: createSignInViewModel(),
                           createSignUpView: createSignUpFactory())
            .environment(EnvironmentFactory.authViewModel)
            .environment(EnvironmentFactory.appState))
    }
    
    private func createSignInViewModel() -> SignInViewModel {
        SignInViewModelImpl()
    }
    
    private func createSignUpFactory() -> SignUpFactory {
        SignUpFactory()
    }
}

final class DashboardFactory: CreateDashboard {
    
    private let sectionMovieFactory = SectionMovieFactory()
    
    @MainActor func createDashboardView() -> AnyView {
        return AnyView(Dashboard(createSectionMovie: sectionMovieFactory)
            .environment(EnvironmentFactory.network)
            .environment(EnvironmentFactory.movieVM))
    }
}
