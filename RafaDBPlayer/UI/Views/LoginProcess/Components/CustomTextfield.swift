//
//  CustomTextfield.swift
//  RafaDBPlayer
//
//  Created by Rafael Loggiodice on 13/12/24.
//

import SwiftUI

struct CustomTextfield: View {
    
    let placeholder: String
    @Binding var text: String
    
    var body: some View {
        ZStack(alignment: .leading) {
            TextField("", text: $text)
                .accessibilityLabel(Text(verbatim: "Registration")) // to have email suggestion in keyboard
                .keyboardType(.emailAddress)
                .textContentType(.emailAddress)
                .textInputAutocapitalization(.never)
                .padding()
                .frame(height: 55)
                .background(.textfieldBackground,
                            in: RoundedRectangle(cornerRadius: 15))
            placeholderView
        }
        .padding()
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    CustomTextfield(placeholder: "Email", text: .constant(""))
}

extension CustomTextfield {
    
    var placeholderView: some View {
        HStack {
            Text(text.isEmpty ? placeholder : "")
                .foregroundStyle(.secondary)
                .padding(.top, 5)
                .padding(.leading)
                .bold()
            Spacer()
            
            Button {
                text = ""
            } label: {
                if !text.isEmpty {
                    Image(systemName: "x.circle.fill")
                        .foregroundStyle(Color(uiColor: .lightGray))
                }
            }
            .padding()
    }
    }
}
