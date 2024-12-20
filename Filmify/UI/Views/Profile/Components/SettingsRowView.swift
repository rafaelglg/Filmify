//
//  SettingsRowView.swift
//  Filmify
//
//  Created by Rafael Loggiodice on 16/12/24.
//

import SwiftUI

struct SettingsRowView: View {
    let initials: String
    let name: String
    let email: String
    
    var body: some View {
        HStack {
            Text(initials)
                .font(.title)
                .fontWeight(.semibold)
                .frame(width: 73, height: 73)
                .background(Color(.systemGray3))
                .clipShape(.circle)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(name)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .padding(.top, 4)
                
                Text(email)
                    .font(.footnote)
                    .tint(.gray)
            }
        }
    }
}

#Preview {
    SettingsRowView(initials: "MJ", name: "Rafael Loggiodice", email: "rafael@gmail.com")
}
