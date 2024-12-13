//
//  SignUpView.swift
//  RafaDBPlayer
//
//  Created by Rafael Loggiodice on 10/12/24.
//

import SwiftUI

struct SignUpView: View {
    var body: some View {
        HStack {
            Text("Important!")
                .frame(width: 200)
                .background(.blue)
            GeometryReader { proxy in
                Image(systemName: "applelogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: proxy.size.width, height: proxy.size.height * 1.8)
                    .background(.red)
            }
        }
    }
    
    func gtet() {
        
    }
}

#Preview {
    SignUpView()
}
