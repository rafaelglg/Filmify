//
//  SectionMovies.swift
//  RafaDBPlayer
//
//  Created by Rafael Loggiodice on 2/12/24.
//

import SwiftUI

struct SectionMovies: View {
    @Environment(MovieViewModel.self) private var movieVM
    
    private let mediaSectionFactory: CreateSectionMovies

    init(mediaSectionFactory: CreateSectionMovies) {
        self.mediaSectionFactory = mediaSectionFactory
    }
    
    var body: some View {
        LazyVStack {
            
            mediaSectionFactory.createMediaSectionView(title: "Now in Cines", movie: movieVM.nowPlayingMovies)
            mediaSectionFactory.createMediaSectionView(title: "Top rated", movie: movieVM.topRatedMovies)
            mediaSectionFactory.createMediaSectionView(title: "Upcoming", movie: movieVM.upcomingMovies)
            mediaSectionFactory.createMediaSectionView(title: "Trending by day", movie: movieVM.trendingMoviesByDay)
            mediaSectionFactory.createMediaSectionView(title: "Trending by week", movie: movieVM.trendingMoviesByWeek)
        }
    }
}

#Preview {
    @Previewable @State var movieUsesCasesImpl = MovieUsesCasesImpl(repository: MovieProductServiceImpl(productService: NetworkService.shared))
    SectionMovies(mediaSectionFactory: MediaSectionFactory())
        .environment(MovieViewModel(movieUsesCase: movieUsesCasesImpl))
}
