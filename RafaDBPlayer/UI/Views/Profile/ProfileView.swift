//
//  ProfileView.swift
//  RafaDBPlayer
//
//  Created by Rafael Loggiodice on 16/12/24.
//

import SwiftUI

struct ProfileView: View {
    
    @Environment(AuthViewModelImpl.self) private var authViewModel
    
    var body: some View {
        NavigationStack {

                List {
                    
                    Section {
                        SettingsRowView(initials: authViewModel.currentUser?.initials ?? "", name: authViewModel.currentUser?.fullName ?? "", email: authViewModel.currentUser?.email ?? "")
                    }
                    
                    Section {
                        Button(role: .destructive) {
                            withAnimation {
                                authViewModel.signOut()
                            }
                        } label: {
                            Text("Sign out")
                        }
                    }
                    
                }
                .navigationTitle("Profile")
            
        }
    }
}

#Preview {
    ProfileView()
        .environment(AuthViewModelImpl())
}
