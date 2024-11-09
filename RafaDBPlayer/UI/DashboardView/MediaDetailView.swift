//
//  MediaDetailView.swift
//  RafaDBPlayer
//
//  Created by Rafael Loggiodice on 7/11/24.
//

import SwiftUI

struct MediaDetailView: View {
    
    let movie: MovieResultResponse
    @State private var progressButtonSelected: CGFloat = 37
    @State private var widthProgressBar: CGFloat = 140
    @State private var selectedButton: LocalizedStringKey = ""
    
    var body: some View {
        
        VStack(spacing: 150) {
            ZStack(alignment: .bottom) {
                backgroundImage
                posterWithInfo
            }
            buttonSection
            Spacer()
        }
    }
}

#Preview {
    VStack {}
        .sheet(isPresented: .constant(true)) {
            MediaDetailView(movie: .preview)
        }
        .preferredColorScheme(.dark)
}

// MARK: - Body
extension MediaDetailView {
    
    var backgroundImage: some View {
        createImage(urlImage: movie.backdropURLImage, imageWidth: UIScreen.main.bounds.width, imageHeight: UIScreen.main.bounds.height * 0.259)
            .ignoresSafeArea(edges: .top)
    }
    
    var posterWithInfo: some View {
        HStack(alignment: .center) {
            Spacer()
            posterImage
            Spacer()
            movieMainDetails
        }
        .frame(width: 350, height: 220)
        .offset(x: -20, y: 140)
    }
    
    var posterImage: some View {
        createImage(urlImage: movie.posterURLImage, imageWidth: 120, imageHeight: UIScreen.main.bounds.height * 0.259, cornerRadius: 10)
            .padding(4)
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .shadow(color: .black.opacity(0.3), radius: 8)
    }
    
    var movieMainDetails: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(movie.title)
                .font(.title2)
                .fontWeight(.bold)
                .frame(width: 150, alignment: .leading)
            HStack {
                Label("\(movie.releaseDate.toYear())", systemImage: "calendar")
                Text("|")
                Text(movie.id.description)
                Text("|")
                Text(movie.adult.description)
            }
            .fixedSize()
            .font(.subheadline)
            .foregroundStyle(.gray)
        }
        .padding(.top, 50)
    }
    
    @ViewBuilder
    var buttonSection: some View {
        VStack {
            HStack {
                Spacer()
                buttonSection(title: "About movie") {
                    
                }
                
                Spacer()
                
                buttonSection(title: "Review") {
                    
                }
                
                Spacer()
                
                buttonSection(title: "Cast") {
                    
                }
                
                Spacer()
            }
            .offset(x: -10)
            .frame(maxWidth: .infinity)
        }
        buttonSelectedBar
        
    }
    
    var buttonSelectedBar: some View {
        ZStack(alignment: .leading) {
            Capsule(style: .continuous)
                .fill(.gray)
                .opacity(0.2)
                .frame(maxWidth: .infinity)
                .frame(height: 4)
                .offset(y: -130)
            
            Capsule(style: .continuous)
                .fill(.blue)
                .frame(width: widthProgressBar, height: 4)
                .offset(x: progressButtonSelected, y: -130)
        }
    }
    
    // MARK: - Functions
    
    func createImage(urlImage: URL, imageWidth: CGFloat, imageHeight: CGFloat? = nil, cornerRadius: CGFloat? = nil) -> some View {
        AsyncImage(url: urlImage) { image in
            image.resizable()
                .scaledToFit()
                .frame(width: imageWidth)
                .clipShape(RoundedRectangle(cornerRadius: cornerRadius ?? 0))
            
        } placeholder: {
            ProgressView()
                .frame(width: imageWidth, height: imageHeight)
        }
    }
    
    /// Update the width of the progressBar below the buttons and the position
    /// - Parameters:
    ///   - title: title of button
    ///   - geometry: injected from func buttonSection
    func updateWidthAndPositionIfNeeded(for title: LocalizedStringKey, geometry: GeometryProxy) {
        let buttonWidth = geometry.size.width
        withAnimation {
            widthProgressBar = buttonWidth + 20
            progressButtonSelected = geometry.frame(in: .global).midX - (widthProgressBar / 2)
        }
    }
    
    func buttonSection(title: LocalizedStringKey, action: @escaping () -> Void) -> some View {
        Button {
            action()
            selectedButton = title
        } label: {
            Text(title)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundStyle(Color(.label))
                .fixedSize(horizontal: false, vertical: true)
                .background(
                    GeometryReader { geometry in
                        Color.clear.onAppear {
                            updateWidthAndPositionIfNeeded(for: title, geometry: geometry)
                        }
                        .onChange(of: selectedButton) { _, newValue in
                            if newValue == title {
                                updateWidthAndPositionIfNeeded(for: title, geometry: geometry)
                            }
                        }
                    }
                )
        }
    }
}
