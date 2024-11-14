//
//  MovieCell.swift
//  RafaDBPlayer
//
//  Created by Rafael Loggiodice on 6/11/24.
//

import SwiftUI

struct MovieCell: View {
    
    let movie: MovieResultResponse
    let imageURL: URL
    let width: CGFloat
    let height: CGFloat
    
    init(movie: MovieResultResponse, imageURL: URL, width: CGFloat = 120, height: CGFloat = 170) {
        self.movie = movie
        self.imageURL = imageURL
        self.width = width
        self.height = height
    }
    
    var body: some View {
        AsyncImage(url: imageURL) { image in
            image.resizable()
                .scaledToFit()
                .clipShape(.rect(cornerRadius: 5))
                .frame(width: width, height: height)
        } placeholder: {
            ProgressView()
                .frame(width: width, height: height)
        }
    }
}

#Preview {
    @Previewable @State var movie = MovieResultResponse.preview
    MovieCell(movie: .preview, imageURL: movie.posterURLImage)
        .padding()
}
