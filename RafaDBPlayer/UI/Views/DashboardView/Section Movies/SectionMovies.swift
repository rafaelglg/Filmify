//
//  SectionMovies.swift
//  RafaDBPlayer
//
//  Created by Rafael Loggiodice on 2/12/24.
//

import SwiftUI

struct SectionMovies: View {
    @Environment(MovieViewModel.self) private var movieVM
    @Environment(\.isSearching) private var isSearching
    
    var body: some View {
        LazyVStack {
            if isSearching {
                // This view shows when the search bar is clicked but and text is empty
                ZStack {
                    Text("You can search movies, by using their names, years of creation...")
                }
                .frame(height: 500)
                .padding()
            } else {
                MediaSectionView(title: "Now in Cines", movie: movieVM.nowPlayingMovies)
                MediaSectionView(title: "Top rated", movie: movieVM.topRatedMovies)
                MediaSectionView(title: "Upcoming", movie: movieVM.upcomingMovies)
                MediaSectionView(title: "Trending by day", movie: movieVM.trendingMoviesByDay)
                MediaSectionView(title: "Trending by week", movie: movieVM.trendingMoviesByWeek)
            }
        }
    }
}

#Preview {
    SectionMovies()
        .environment(MovieViewModel())
}
