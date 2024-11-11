//
//  MediaDetailView.swift
//  RafaDBPlayer
//
//  Created by Rafael Loggiodice on 7/11/24.
//

import SwiftUI

struct MediaDetailView: View {
    
    @Environment(MovieViewModel.self) private var movieVM
    let movie: MovieResultResponse
    @State private var progressButtonSelected: CGFloat = 37
    @State private var widthProgressBar: CGFloat = 140
    @State private var selectedButton: LocalizedStringKey = ""
    
    var body: some View {
        
        ZStack(alignment: .bottom) {
            backgroundImage
            posterWithInfo
        }
        
        VStack(spacing: 180) {
            buttonSection
            
            ScrollView {
                VStack(alignment: .leading, spacing: 30) {
                    infoMovie
                    statusFilm
                    productionCompaniesTitle
                    GridInfoCell()
                }
                .frame(maxWidth: UIWindow().screen.bounds.width * 0.80)
                .frame(maxWidth: UIWindow().screen.bounds.width)
            }
        }
    }
}

#Preview {
    MediaDetailView(movie: .preview)
        .environment(MovieViewModel())
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
            posterImage
            movieMainDetails
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .offset(y: 150) // To have the position between bgImage y buttons
    }
    
    var posterImage: some View {
        createImage(urlImage: movie.posterURLImage, imageWidth: 120, imageHeight: 130, cornerRadius: 10, bgColor: true)
            .frame(width: 140, alignment: .leading)
    }
    
    var movieMainDetails: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(movie.title)
                .font(.title2)
                .fontWeight(.bold)
                .frame(width: 180, alignment: .leading)
            
            VStack(alignment: .leading, spacing: 5) {
                HStack(spacing: 4) {
                    Label("\(movie.releaseDate.toYear())", systemImage: "calendar")
                    Text("|")
                    Label("\(movieVM.detailMovie?.runtime.description ?? "no info yet in") minutes", systemImage: "clock")
                }
                Label(movieVM.detailMovie?.genresFormatted ?? "no genre", systemImage: "ticket")
                Label("revenue: \(movieVM.detailMovie?.revenueFormatted ?? "")", systemImage: "dollarsign")
            }
            .font(.caption)
            .foregroundStyle(.secondary)
        }
    }
    
    @ViewBuilder
    var buttonSection: some View {
        VStack {
            HStack(spacing: 50) {
                buttonSection(title: "About movie") {}
                
                buttonSection(title: "Review") {}
                
                buttonSection(title: "Cast") {}
            }
            .frame(maxWidth: .infinity, alignment: .center)
            buttonSelectedBar
        }
        .offset(y: 180) // move the position of buttons
    }
    
    var buttonSelectedBar: some View {
        ZStack(alignment: .leading) {
            Capsule(style: .continuous)
                .fill(.gray)
                .opacity(0.2)
                .frame(maxWidth: .infinity)
                .frame(height: 4)
            
            Capsule(style: .continuous)
                .fill(.blue)
                .frame(width: widthProgressBar, height: 4)
                .offset(x: progressButtonSelected)
        }
    }
    
    var infoMovie: some View {
        VStack(alignment: .leading) {
            Text(movie.overview)
                .padding(.vertical, 25)
            
            Text("Spoken languages")
                .font(.title2)
                .bold()
            VStack(alignment: .leading) {
                if let detailMovie = movieVM.detailMovie {
                    ForEach(detailMovie.spokenLanguages) { language in
                        HStack(spacing: 5) {
                            Text(language.countryFlag(countryCode: language.countryCodeName))
                            Text(language.englishName)
                        }
                    }
                    .font(.headline)
                }
            }
        }
    }
    
    var statusFilm: some View {
        HStack {
            let status = movieVM.detailMovie?.status
            
            Image(systemName: "movieclapper")
            Text("Status film: ")
                .font(.title2)
                .bold()
            
            Text(status ?? "")
                .font(.title3)
                .bold()
                .foregroundStyle(status == "Released" ? .green : .primary)
        }
    }
    
    var productionCompaniesTitle: some View {
        Text("Production companies")
            .font(.title2)
            .bold()
    }
    
    // MARK: - Functions
    
    func createImage(urlImage: URL, imageWidth: CGFloat, imageHeight: CGFloat? = nil, cornerRadius: CGFloat? = nil, bgColor: Bool = false) -> some View {
        AsyncImage(url: urlImage) { image in
            image.resizable()
                .scaledToFit()
                .frame(width: imageWidth)
                .clipShape(RoundedRectangle(cornerRadius: cornerRadius ?? 0))
                .background(
                    Group {
                        if bgColor {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(.white)
                                .frame(width: 130, height: 190)
                        }
                    }
                )
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
