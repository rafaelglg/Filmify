//
//  MediaSectionView.swift
//  RafaDBPlayer
//
//  Created by Rafael Loggiodice on 7/11/24.
//

import SwiftUI

struct MediaSectionView: View {
    
    let title: String
    let movie: [MovieResultResponse]
    @Binding var selectedMovie: MovieResultResponse?
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.title3)
                .fontWeight(.bold)
            
            ScrollView(.horizontal) {
                LazyHStack(spacing: 3) {
                    ForEach(movie) { movie in
                        MovieCell(movie: movie, imageURL: movie.posterURLImage)
                            .onTapGesture {
                                selectedMovie = movie
                            }
                    }
                }
            }
            .sheet(item: $selectedMovie) { movie in
                MediaDetailView(movie: movie)
                    .onAppear {
                        // fetch more detail movie
                    }
            }
            .presentationCornerRadius(15)
            .scrollIndicators(.hidden)
        }
        .padding(.leading)
        .padding(.top)
    }
}

#Preview {
    MediaSectionView(title: "Movies", movie: [.preview], selectedMovie: .constant(.none))
}
