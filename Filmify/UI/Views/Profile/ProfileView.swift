//
//  ProfileView.swift
//  Filmify
//
//  Created by Rafael Loggiodice on 16/12/24.
//

import SwiftUI

struct ProfileView: View {
    
    @Environment(AuthViewModelImpl.self) private var authViewModel
    
    var body: some View {
        @Bindable var authViewModel = authViewModel
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
                    
                    Button(role: .cancel) {
                        authViewModel.getkeyFromKeychain()
                    } label: {
                        Text("Get password from keychain")
                    }
                }
                .alert("keychain", isPresented: $authViewModel.showErrorAlert) {
                    Button("Ok") {
                        authViewModel.showErrorAlert = false
                    }
                } message: {
                    Text(authViewModel.authErrorMessage)
                }
                
                Section {
                    Button(role: .destructive) {
                        withAnimation {
                            authViewModel.deleteUser()
                        }
                    } label: {
                        Text("Delete account")
                    }
                    
                    Button(role: .destructive) {
                        withAnimation {
                            authViewModel.clearKeychain()
                        }
                    } label: {
                        Text("Delete all keychains")
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
        .environment(AuthViewModelImpl.preview)
}
