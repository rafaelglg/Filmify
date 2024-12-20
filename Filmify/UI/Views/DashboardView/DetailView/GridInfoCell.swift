//
//  GridInfoCell.swift
//  Filmify
//
//  Created by Rafael Loggiodice on 10/11/24.
//

import SwiftUI

struct GridInfoCell: View {
    @Environment(MovieViewModel.self) private var movieVM
    let columns = Array(repeating: GridItem(.flexible()), count: 2)
    
    var body: some View {
        
        LazyVGrid(columns: columns, alignment: .leading, spacing: 20) {
            productionCompany
        }
    }
    
    func imageLogo(url: URL?, logoPath: String?) -> some View {
        AsyncImage(url: url) { image in
            image.resizable()
                .scaledToFit()
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.primary)
                        .frame(width: 60, height: 60)
                )
                .frame(width: 50, height: 50)
            
        } placeholder: {
            if logoPath != nil {
                ProgressView()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
            }
        }
    }
}

#Preview {
    
    @Previewable @State var movieUsesCasesImpl = MovieUsesCasesImpl(repository: MovieProductServiceImpl(productService: NetworkService.shared))
    
    GridInfoCell()
        .padding()
        .preferredColorScheme(.dark)
        .environment(MovieViewModel(movieUsesCase: movieUsesCasesImpl))
}

extension GridInfoCell {
    var noImageLogo: some View {
        RoundedRectangle(cornerRadius: 10)
            .overlay {
                Text("no image")
                    .font(.caption)
                    .foregroundStyle(.black)
            }
            .offset(x: -5)
            .frame(width: 60, height: 60, alignment: .center)
    }
    
    func companiesInfo(name: String, originCountry: String) -> some View {
        VStack(alignment: .leading) {
            
            Text(name)
                .font(.caption)
                .bold()
            
            if !originCountry.isEmpty {
                Text(originCountry)
                    .font(.caption2)
                    .fontWeight(.light)
            }
        }
    }
    
    @ViewBuilder
    var productionCompany: some View {
        if let proCompanies = movieVM.detailMovie?.productionCompanies {
            ForEach(proCompanies, id: \.id) { companies in
                
                HStack(alignment: .center, spacing: companies.logoPath != nil ? 10 : 2) {
                    if companies.logoPath == nil {
                        noImageLogo
                    }
                    
                    imageLogo(url: companies.logoURL, logoPath: companies.logoPath)
                    
                    companiesInfo(name: companies.name, originCountry: companies.originCountry)
                    
                }
            }
        }
    }
}
