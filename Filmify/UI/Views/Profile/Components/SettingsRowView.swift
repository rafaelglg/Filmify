//
//  SettingsRowView.swift
//  Filmify
//
//  Created by Rafael Loggiodice on 16/12/24.
//

import SwiftUI

struct SettingsRowView: View {
    let user: UserModel
    
    var body: some View {
        HStack {
            Text(user.initials)
                .font(.title)
                .fontWeight(.semibold)
                .frame(width: 73, height: 73)
                .background(Color(.systemGray3))
                .clipShape(.circle)
            
            VStack(alignment: .leading, spacing: 5) {
                Text(user.fullName)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                
                if !user.email.isEmpty {
                    Text(user.email)
                        .font(.footnote)
                        .tint(.gray)
                }
            }
        }
    }
}

#Preview {
    SettingsRowView(user: UserModel(id: "1", email: "mj@gmail.com", password: "", fullName: "Michael Jackson", sessionId: ""))
}
