//
//  PersonDetailView.swift
//  RafaDBPlayer
//
//  Created by Rafael Loggiodice on 19/11/24.
//

import SwiftUI

struct PersonDetailView<T>: View {
    let person: T
    let personDetail: PersonDetailModel
    @State var isExpandedBio: Bool = false
    
    var body: some View {
        ScrollView {
            if let cast = person as? CastResponseModel {
                VStack {
                    castImage(cast: cast)
                    VStack(alignment: .leading, spacing: 10) {
                        castInfo(cast: cast)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(30)
                }
            }
            
            if let crew = person as? CrewResponseModel {
                
                VStack {
                    if crew.profilePath != nil {
                        AsyncImage(url: crew.profileImageURL) { image in
                            image.resizable()
                                .cropImage()
                            
                        } placeholder: {
                            ProgressView()
                                .frame(width: UIScreen.main.bounds.width, height: 500, alignment: .center)
                                .clipShape(RoundedRectangle(cornerRadius: 30))
                        }
                    } else {
                        noImageLogo
                    }
                    VStack(alignment: .leading, spacing: 10) {
                        Text(crew.name)
                            .font(.title)
                            .bold()
                        
                        Text(crew.job)
                            .font(.title2)
                            .bold()
                        
                        Text(personDetail.biography)
                            .lineLimit(isExpandedBio ? nil : 3)
                            .font(.body)

                        if !personDetail.biography.isEmpty && personDetail.biography.count > 60 {
                            buttonSeeMore
                        }
                        
                        personDetailInfo
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(30)
                }
            }
        }
    }
}

#Preview {
    ScrollView {
        PersonDetailView(person: CastResponseModel.preview.first, personDetail: PersonDetailModel.preview)
        PersonDetailView(person: CrewResponseModel.preview.first, personDetail: PersonDetailModel.preview)
        
            .preferredColorScheme(.dark)
    }
}

extension PersonDetailView {
    var noImageLogo: some View {
        ZStack(alignment: .center) {
            RoundedRectangle(cornerRadius: 30)
            Text("No image")
                .foregroundStyle(Color(.black))
                .font(.title2)
        }
        .frame(width: 300, height: 300, alignment: .top)
    }
    
    @ViewBuilder
    func castImage(cast: CastResponseModel) -> some View {
        if cast.profilePath != nil {
            AsyncImage(url: cast.imageURL) { image in
                image.resizable()
                    .cropImage()
                
            } placeholder: {
                ProgressView()
                    .frame(width: UIScreen.main.bounds.width, height: 500, alignment: .center)
                    .clipShape(RoundedRectangle(cornerRadius: 30))
            }
        } else {
            noImageLogo
        }
    }
    
    @ViewBuilder
    func castInfo(cast: CastResponseModel) -> some View {
        Text(cast.name)
            .font(.title)
            .bold()
        Text(cast.character)
            .font(.title3)
            .bold()
        
        Text(personDetail.biography)
            .lineLimit(isExpandedBio ? nil : 3)
            .font(.body)
            .padding(.top)
        
        if !personDetail.biography.isEmpty && personDetail.biography.count > 60 {
            buttonSeeMore
        }
        
        personDetailInfo
    }
    
    var buttonSeeMore: some View {
        Button {
            isExpandedBio.toggle()
        } label: {
            Text( isExpandedBio ? "See less" : "See more...")
                .font(.callout)
                .fontWeight(.heavy)
        }
        .padding(.bottom)
    }
    
    @ViewBuilder
    var personDetailInfo: some View {
        if personDetail.placeOfBirth != nil || personDetail.birthday != nil {
            Label("Important details", systemImage: "lightbulb.fill")
                .font(.title2)
                .bold()
                .padding(.top)
            Text("Birthday: \(personDetail.dateOfBirthFormatted)")
            Text("Born in: \(personDetail.placeOfBirth ?? "")")
            if personDetail.isDead() {
                Text("Death: \(personDetail.deathDayFormatted)")
            } else {
                Text("age: \(personDetail.age) years")
            }
            
            if personDetail.hasWebsite {
                HStack(alignment: .bottom) {
                    Text("Website: ")
                        .foregroundStyle(.primary)
                    
                    Link(destination: personDetail.homePageURL) {
                        Text(personDetail.homePageURL.host() ?? "")
                            .font(.body)
                    }
                }
            }
        }
    }
}

extension View {
    func cropImage() -> some View {
        self
            .scaledToFill()
            .frame(width: UIScreen.main.bounds.width, height: 500, alignment: .top)
            .clipShape(RoundedRectangle(cornerRadius: 30))
    }
}
