//
//  CustomTextField.swift
//  TrendingMovies
//
//  Created by Mohamed Sayed on 02/10/2024.
//

import SwiftUI

struct CustomTextField: View {
    @Binding var text: String
    var placeholder: String
    var placeholderColor: Color = .gray
    var textColor: Color = .white
    var backgroundColor: Color = Color.gray.opacity(0.2)
    var borderColor: Color = .white
    var cornerRadius: CGFloat = 10
    var borderWidth: CGFloat = 1.5
    var padding: CGFloat = 16

    var body: some View {
        ZStack(alignment: .leading) {
            if text.isEmpty {
                Text(placeholder)
                    .foregroundColor(placeholderColor)
                    .padding(.leading, padding)
            }
            
            TextField("", text: $text)
                .padding(padding)
                .foregroundColor(textColor)
                .background(backgroundColor)
                .cornerRadius(cornerRadius)
                .overlay(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(borderColor, lineWidth: borderWidth)
                )
        }
    }
}
