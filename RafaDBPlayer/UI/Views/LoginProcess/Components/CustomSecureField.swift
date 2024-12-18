//
//  CustomSecureField.swift
//  RafaDBPlayer
//
//  Created by Rafael Loggiodice on 13/12/24.
//

import SwiftUI

struct CustomSecureField: View {
    
    let placeholder: String
    @Binding var passwordText: String
    
    var body: some View {
        ZStack(alignment: .leading) {
            SecureField("", text: $passwordText)
                .padding()
                .textContentType(.password)
                .frame(height: 55)
                .background(.textfieldBackground,
                            in: RoundedRectangle(cornerRadius: 15))
            
            placeholderView
        }
        .padding()
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    CustomSecureField(placeholder: "Password", passwordText: .constant(""))
}

extension CustomSecureField {
    
    var placeholderView: some View {
        HStack {
            Text(passwordText.isEmpty ? placeholder : "")
                .foregroundStyle(.secondary)
                .padding(.top, 5)
                .padding(.leading)
                .bold()
            Spacer()
            
            Button {
                passwordText = ""
            } label: {
                if !passwordText.isEmpty {
                    Image(systemName: "x.circle.fill")
                        .foregroundStyle(Color(uiColor: .lightGray))
                }
            }
            .padding()
        }
    }
}
