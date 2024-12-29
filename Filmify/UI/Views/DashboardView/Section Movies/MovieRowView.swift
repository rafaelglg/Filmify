//
//  MovieRowView.swift
//  Filmify
//
//  Created by Rafael Loggiodice on 3/12/24.
//

import SwiftUI

struct MovieRowView: View {
    let movies: [MovieResultResponse]
    let onSelect: (MovieResultResponse) -> Void
    
    var body: some View {
        ScrollView(.horizontal) {
            LazyHStack(spacing: 3) {
                ForEach(movies, id: \.id) { movie in
                    MovieCell(movie: movie, imageURL: movie.posterURLImage)
                        .onTapGesture {
                            onSelect(movie)
                        }
                }
            }
        }
        .scrollIndicators(.hidden)
    }
}

#Preview {
    MovieRowView(movies: [MovieResultResponse.preview]) {_ in }
}
