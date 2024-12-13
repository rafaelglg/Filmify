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
    @FocusState var focusField: FieldState?
    
    var body: some View {
        ZStack(alignment: .leading) {
            SecureField("", text: $passwordText)
                .padding()
                .frame(height: 55)
                .background(.textfieldBackground,
                            in: RoundedRectangle(cornerRadius: 15))
            
            Text(placeholder)
                .foregroundStyle(.secondary)
                .padding(.top, 5)
                .padding(.leading)
                .offset(y: focusField != nil ? -50 : 0)
                .bold()
        }
        .padding()
        .animation(focusField != nil ? .linear : .none, value: focusField)
    }
}

#Preview {
    CustomSecureField(placeholder: "Password", passwordText: .constant(""))
}
