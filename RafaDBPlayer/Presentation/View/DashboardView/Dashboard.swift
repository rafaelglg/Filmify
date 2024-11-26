//
//  Dashboard.swift
//  RafaDBPlayer
//
//  Created by Rafael Loggiodice on 6/11/24.
//

import SwiftUI

struct Dashboard: View {
    
    @Environment(MovieViewModel.self) var movieVM
    
    var body: some View {
        @Bindable var movieVM = movieVM
        NavigationStack {
            ZStack {
                ScrollView {
                    
                    MediaSectionView(title: "Now in Cines", movie: movieVM.nowPlayingMovies)
                    MediaSectionView(title: "Top rated", movie: movieVM.topRatedMovies)
                    MediaSectionView(title: "Upcoming", movie: movieVM.upcomingMovies)
                    MediaSectionView(title: "Trending by day", movie: movieVM.trendingMoviesByDay)
                    MediaSectionView(title: "Trending by week", movie: movieVM.trendingMoviesByWeek)
                }
                
                .refreshable {
                    movieVM.getDashboard()
                }
                .sheet(isPresented: $movieVM.showProfile) {
                    RafaView()
                }
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            withAnimation(.spring) {
                                movieVM.showProfile.toggle()
                            }
                        } label: {
                            Text("Rafa")
                                .font(.callout)
                                .fontWeight(.bold)
                                .foregroundStyle(Color(.label))
                        }
                    }
                    
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            
                        } label: {
                            Image(systemName: "magnifyingglass")
                                .tint(.white)
                                .fontWeight(.bold)
                        }
                        
                    }
                }
                .onAppear {
                    movieVM.getDashboard()
                }
                .preferredColorScheme(.dark)
                
                progressView
            }
        }
    }
}

#Preview {
    Dashboard()
        .environment(MovieViewModel())
}

extension Dashboard {
    
    @ViewBuilder
    var progressView: some View {
        if movieVM.isLoading {
            Color.black.opacity(0.5)
                .ignoresSafeArea()
            
            VStack {
                ProgressView()
                    .frame(width: 80, height: 80)
                    .cornerRadius(8)
                    .padding(.bottom, 10)
                
                Text("Please wait...")
                    .font(.callout)
                    .foregroundColor(.white)
            }
        }
    }
}
