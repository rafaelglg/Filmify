//
//  RatingPopoverView.swift
//  Filmify
//
//  Created by Rafael Loggiodice on 23/12/24.
//

import SwiftUI

struct RatingPopoverView: View {
    
    let movie: MovieResultResponse
    @Binding var movieReviewVM: MovieReviewViewModel
    @State private var selectedStars: [Bool] = Array(repeating: false, count: 5)

    var body: some View {
        VStack(spacing: 10) {
            if $movieReviewVM.wrappedValue.isMovieRated(movieId: movie.id.description) {
                ratedView
            } else {
                notRatedView
            }
        }
    }
}

#Preview {
    
    @Previewable @State var movieReviewVM = MovieReviewViewModelImpl(movieReviewUsesCase: MovieReviewUsesCaseImpl(repository: MovieReviewServiceImpl(productService: ReviewProductServiceImpl(networkService: NetworkService.shared))))
    movieReviewVM.movieRatedStatus["1"] = true
    movieReviewVM.ratingValue = 5
    
    return RatingPopoverView(movie: MovieResultResponse.preview,
                      movieReviewVM: .constant(movieReviewVM))
}

extension RatingPopoverView {
    
    @ViewBuilder
    var ratedView: some View {
        Text("Movie already rated")
            .font(.headline)
            .foregroundStyle(.primary)
            .bold()
        Text("You rated with \(movieReviewVM.ratingValue, specifier: "%.f")")
            .font(.headline)
            .foregroundStyle(.primary)
            
    }
    
    @ViewBuilder
    var notRatedView: some View {
        Text("Give stars to this movie")
            .font(.headline)
            .bold()
        HStack {
            ForEach(0..<5, id: \.self) { index in
                Button {
                    for ind in 0..<5 {
                        selectedStars[ind] = ind <= index
                    }
                    
                    let newRatingValue = (Float(index + 1) * 2.0)
                    movieReviewVM.ratingValue = round(newRatingValue * 100) / 100
                } label: {
                    Image(systemName: selectedStars[index] ? "star.fill" : "star")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                        .foregroundStyle(selectedStars[index] ? .yellow : Color(uiColor: .lightGray))
                }
            }
        }
        Text("Rating Value: \(movieReviewVM.ratingValue, specifier: "%.f")")
            .font(.subheadline)
            .bold()
        sendButton
    }
    
    var sendButton: some View {
        Button {
            movieReviewVM.postRatingMovie(movieId: movie.id.description, rating: movieReviewVM.ratingValue)
            movieReviewVM.showRatingPopover = false
        } label: {
            
            Text("Send rate")
                .bold()
                .frame(width: 200, height: 40)
                .foregroundStyle(.primary)
        }
        .background(.buttonBG, in: RoundedRectangle(cornerRadius: 15))
        .padding(.top)
    }
}
