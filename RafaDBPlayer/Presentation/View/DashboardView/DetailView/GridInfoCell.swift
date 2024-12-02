//
//  GridInfoCell.swift
//  RafaDBPlayer
//
//  Created by Rafael Loggiodice on 10/11/24.
//

import SwiftUI

struct GridInfoCell: View {
    @Environment(MovieViewModel.self) private var movieVM
    let columns = Array(repeating: GridItem(.flexible()), count: 2)
    
    var body: some View {
        
        LazyVGrid(columns: columns, alignment: .leading, spacing: 20) {
            
            ForEach(movieVM.detailMovie?.productionCompanies ?? []) { companies in
                
                HStack(spacing: companies.logoPath != nil ? 10 : 0) {
                    if companies.logoPath == nil {
                        noImageLogo
                    }
                    
                    imageLogo(url: companies.logoURL, logoPath: companies.logoPath)
                    
                    VStack(alignment: .leading) {
                        companiesInfo(name: companies.name, originCountry: companies.originCountry)
                    }
                }
            }
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
    
    @ViewBuilder
    func companiesInfo(name: String, originCountry: String) -> some View {
        Text(name)
            .font(.caption)
            .bold()
        
        Text(originCountry)
            .font(.caption2)
            .fontWeight(.light)
    }
}

#Preview {
    GridInfoCell()
        .padding()
        .preferredColorScheme(.dark)
        .environment(MovieViewModel())
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
            .frame(width: 60, height: 60, alignment: .leading)
    }
}
