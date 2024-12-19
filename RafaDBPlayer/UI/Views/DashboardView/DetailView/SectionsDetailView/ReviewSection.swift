//
//  ReviewSection.swift
//  RafaDBPlayer
//
//  Created by Rafael Loggiodice on 12/11/24.
//

import SwiftUI

struct ReviewSection<ImageView: View>: View {
    let review: MovieReviewResponse
    let movieReviewVM: MovieReviewViewModel
    let image: ImageView
    
    init(review: MovieReviewResponse, movieReviewVM: MovieReviewViewModel, @ViewBuilder imageView: () -> ImageView) {
        self.review = review
        self.movieReviewVM = movieReviewVM
        self.image = imageView()
    }
    
    var body: some View {
        LazyVStack(alignment: .leading, spacing: 20) {
            LazyHStack {
                if review.authorDetails.avatarPath == nil {
                    noImageLogo
                }
                image
                VStack(alignment: .leading) {
                    authorName
                    rating
                    Text("Date: \(review.creationDateFormatted)")
                        .font(.caption)
                }
            }
            // i'm using a dictionary to access the value from the key
            Text(movieReviewVM.htmlConvertedTexts[review.id] ?? "")
        }
        .onAppear {
            // this is used because some content from reviews has HTML tags.
            movieReviewVM.sinkHTML2String(for: review.id, text: review.content)
        }
        .padding(.top)
    }
}

#Preview {
    @Previewable @State var review: MovieReviewResponse = .preview
    @Previewable @State var movieReviewViewModel = MovieReviewViewModel(movieReviewUsesCase: MovieReviewUsesCaseImpl(repository: MovieReviewServiceImpl(productService: ReviewProductServiceImpl(networkService: NetworkService.shared))))
    
    ReviewSection(review: .preview,
                  movieReviewVM: movieReviewViewModel,
                  imageView: {
        AsyncImage(url: review.authorDetails.avatarPathURL) {
            $0.image?.resizable()
                .frame(width: 100, height: 100)
                .scaledToFill()
                .clipShape(.circle)
        }
    })
}

extension ReviewSection {
    
    var authorName: some View {
        Text(review.author)
    }
    
    @ViewBuilder
    var rating: some View {
        if review.authorDetails.rating == nil {
            Text("Rating: no rating")
        } else {
            Text("Rating: \(review.authorDetails.rating?.description ?? "") out of 10")
        }
    }
    
    var noImageLogo: some View {
        ZStack(alignment: .center) {
            Circle()
            Text("no image")
                .foregroundStyle(Color(.black))
                .font(.caption)
        }
        .frame(width: 80, height: 80, alignment: .center)
        .padding(.trailing)
    }
}
