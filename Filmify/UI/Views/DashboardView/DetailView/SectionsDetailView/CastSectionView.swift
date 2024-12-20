//
//  CastSectionView.swift
//  Filmify
//
//  Created by Rafael Loggiodice on 15/11/24.
//

import SwiftUI

struct CastSectionView: View {
    let cast: CastResponseModel?
    let crew: CrewResponseModel?
    
    var body: some View {
        HStack(alignment: .center, spacing: 10) {
            
            if cast?.profilePath ?? crew?.profilePath != nil {
                let imageURL = cast?.imageURL ?? crew?.profileImageURL
                AsyncImage(url: imageURL) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 80, height: 80)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.white, lineWidth: 2))
                } placeholder: {
                    ProgressView()
                        .frame(width: 80, height: 80)
                        .background(Color.gray)
                        .clipShape(Circle())
                    
                }
            } else {
                noImageLogo
            }
            
            LazyVStack(alignment: .leading, spacing: 5) {
                if let character = cast?.character {
                    Text(character)
                        .font(.headline)
                        .bold()
                        .multilineTextAlignment(.leading)
                } else if let job = crew?.job {
                    Text(job)
                        .font(.headline)
                        .bold()
                        .multilineTextAlignment(.leading)
                }
                
                if let name = cast?.name ?? crew?.name {
                    Text(name)
                        .font(.subheadline)
                }
                
                if let department = cast?.knownForDepartment ?? crew?.department {
                    Text(department)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.white)
        }
        .padding(10)
        .cornerRadius(8)
    }
}

#Preview {
    
    @Previewable let combineData = Array(zip(CastResponseModel.preview, CrewResponseModel.preview))
    
    ForEach(combineData, id: \.0.id) { cast, crew  in
        CastSectionView(cast: cast, crew: crew)
            .padding()
    }
    .preferredColorScheme(.dark)
}

extension CastSectionView {
    var noImageLogo: some View {
        ZStack(alignment: .center) {
            Circle()
            Text("no image")
                .foregroundStyle(Color(.black))
                .font(.caption)
        }
        .frame(width: 80, height: 80)
    }
}
