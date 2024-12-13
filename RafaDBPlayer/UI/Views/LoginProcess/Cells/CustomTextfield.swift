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
    @FocusState var focusField: FieldState?
    
    var body: some View {
        ZStack(alignment: .leading) {
            TextField("", text: $text)
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
    CustomTextfield(placeholder: "Email", text: .constant(""))
}
