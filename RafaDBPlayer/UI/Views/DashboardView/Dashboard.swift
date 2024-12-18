//
//  Dashboard.swift
//  RafaDBPlayer
//
//  Created by Rafael Loggiodice on 6/11/24.
//

import SwiftUI

struct Dashboard: View {
    
    @Environment(MovieViewModel.self) var movieVM
    @Environment(NetworkMonitorImpl.self) var network
    
    var body: some View {
        ZStack {
                if let network = network.isConnected {
                    if !network {
                        NoInternetConnectionView()
                    } else {
                        showDashboard
                    }
                } else {
                    customProgressView
                }
            if movieVM.isLoadingDetailView {
                customProgressView
            }
        }
        .scrollDismissesKeyboard(.immediately)
        .preferredColorScheme(.dark)
        .clipped()
        .onAppear {
            movieVM.getDashboard()
        }
    }
}

#Preview {
    Dashboard()
        .environment(MovieViewModel())
        .environment(NetworkMonitorImpl())
}

extension Dashboard {
    
    @ViewBuilder
    // This progress view appears when clicking in a movie from dashboard
    var customProgressView: some View {
        Color.black.opacity(0.7)
            .ignoresSafeArea()
        
        VStack {
            ProgressView()
                .frame(width: 80, height: 50)
                .cornerRadius(8)
            
            Text("Please wait...")
                .font(.callout)
                .foregroundColor(.white)
        }
    }
    
    @ViewBuilder
    var showDashboard: some View {
        @Bindable var movieVM = movieVM
        ScrollView {
            sectionMovies
                .alert("App error", isPresented: $movieVM.showingAlert) {
                    Button("Ok") {}
                } message: { Text(movieVM.alertMessage) }
            
                .sheet(isPresented: $movieVM.showProfile) { RafaView() }
            
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            movieVM.showProfile.toggle()
                        } label: {
                            Text("Rafa")
                                .font(.callout)
                                .fontWeight(.bold)
                                .foregroundStyle(Color(.label))
                        }
                    }
                }
        }
    }
    
    var sectionMovies: some View {
        SectionMovies()
    }
}
