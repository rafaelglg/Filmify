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
                    NavigationLink {
                        RafaView()
                    } label: {
                        SettingsRowView(initials: authViewModel.currentUser?.initials ?? "", name: authViewModel.currentUser?.fullName ?? "", email: authViewModel.currentUser?.email ?? "")
                    }
                }
                
                Section {
                    Button(role: .cancel) {
                        withAnimation {
                            authViewModel.signOut()
                        }
                    } label: {
                        Text("Sign out")
                    }
                }
                
                Section {
                    Button(role: .cancel) {
                        withAnimation {
                            
                            authViewModel.getkeyFromKeychain()
                        }
                    } label: {
                        Text("Get password from keychain")
                    }
                } footer: {
                    Text("You will get your data from keychain.")
                }
                
                Section {
                    Button(role: .destructive) {
                        withAnimation {
                            
                            authViewModel.deleteFromKeychain(email: authViewModel.currentUser?.email ?? "")
                        }
                    } label: {
                        Text("Delete password from keychain")
                    }
                } footer: {
                    Text("You will delete all your data from keychain and there is no coming back.")
                }
                
                Section {
                    Button(role: .destructive) {
                        withAnimation {
                            authViewModel.deleteFromKeychain(email: authViewModel.currentUser?.email ?? "")
                            authViewModel.signOut()
                        }
                    } label: {
                        Text("Delete account")
                    }
                } footer: {
                    Text("You will delete all your data, and there is no coming back.")
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
