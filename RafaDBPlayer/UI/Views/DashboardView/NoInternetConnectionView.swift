//
//  NoInternetConnectionView.swift
//  RafaDBPlayer
//
//  Created by Rafael Loggiodice on 5/12/24.
//

import SwiftUI

struct NoInternetConnectionView: View {
    
    var body: some View {
        VStack {
            ContentUnavailableView("No internet connection", systemImage: "wifi.slash", description: Text("Please check your internet connection and try again later."))
        }
    }
}

#Preview {
    NoInternetConnectionView()
        .environment(MovieViewModel())
}
