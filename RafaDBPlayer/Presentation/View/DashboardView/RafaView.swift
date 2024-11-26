//
//  RafaView.swift
//  RafaDBPlayer
//
//  Created by Rafael Loggiodice on 26/11/24.
//

import SwiftUI

struct RafaView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            List {
                Section("Apple developer") {
                    Text("This app was developed by Rafael Loggiodice, using 100% **SwiftUI** and **Combine**.")
                        .font(.callout)
                }
            }
            .toolbar {
                Button("Close") {
                    dismiss()
                }
            }
        }
    }
}

#Preview {
    RafaView()
}
