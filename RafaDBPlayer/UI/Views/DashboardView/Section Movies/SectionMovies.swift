//
//  SectionMovies.swift
//  RafaDBPlayer
//
//  Created by Rafael Loggiodice on 2/12/24.
//

import SwiftUI

struct SectionMovies: View {
    @Environment(MovieViewModel.self) private var movieVM
    
    var body: some View {
        LazyVStack {
            MediaSectionView(title: "Now in Cines", movie: movieVM.nowPlayingMovies)
            MediaSectionView(title: "Top rated", movie: movieVM.topRatedMovies)
            MediaSectionView(title: "Upcoming", movie: movieVM.upcomingMovies)
            MediaSectionView(title: "Trending by day", movie: movieVM.trendingMoviesByDay)
            MediaSectionView(title: "Trending by week", movie: movieVM.trendingMoviesByWeek)
        }
    }
}

#Preview {
    SectionMovies()
        .environment(MovieViewModel())
}
