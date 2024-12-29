//
//  ProfileView.swift
//  Filmify
//
//  Created by Rafael Loggiodice on 16/12/24.
//

import SwiftUI

struct ProfileView: View {
    
    @Environment(AuthViewModelImpl.self) private var authViewModel
    @State var deleteUserAlert: Bool = false
    
    var body: some View {
        @Bindable var authViewModel = authViewModel
        NavigationStack {
            
            List {
                
                Section {
                    NavigationLink {
                        RafaView()
                    } label: {
                        if authViewModel.isLoadingSignInSession {
                            SettingsRowView(user: UserModel.preview)
                                .redacted(reason: .placeholder)
                        } else {
                            SettingsRowView(user: authViewModel.currentUser ?? UserModel.none)
                                .onLongPressGesture(minimumDuration: 3.0) {
                                    authViewModel.setUserAsAdmin(true)
                                }
                        }
                    }
                }
                
                Section {
                    
                    Button(role: .destructive) {
                        withAnimation {
                            authViewModel.signOut()
                        }
                    } label: {
                        Text("Sign out")
                    }
                    
                    Button(role: .destructive) {
                        deleteUserAlert.toggle()
                    } label: {
                        Text("Delete account")
                    }
                    
                    .alert("Delete user", isPresented: $deleteUserAlert) {
                        Button(role: .destructive) {
                            withAnimation {
                                authViewModel.deleteUser()
                            }
                        } label: {
                            Text("delete")
                        }

                    } message: {
                        Text("Are you sure you want to delete your user?")
                    }
                    
                } header: {
                    Text("Sign out options")
                        .font(.headline)
                        .textCase(.lowercase)
                } footer: {
                    Text("You will delete all your data, and there is no coming back.")
                }
                
                if authViewModel.getAdminUser() {
                    
                    Section {
                        
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
                    
                    Button(role: .destructive) {
                        withAnimation {
                            authViewModel.clearKeychain()
                        }
                    } label: {
                        Text("Delete all keychains")
                    }
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
