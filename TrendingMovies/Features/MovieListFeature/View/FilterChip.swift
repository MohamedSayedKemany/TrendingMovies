//
//  FilterChip.swift
//  TrendingMovies
//
//  Created by Mohamed Sayed on 30/09/2024.
//

import SwiftUI

struct FilterChip: View {
    let genre: Genre
    let isSelected: Bool
    let onSelect: (Bool) -> Void
    
    var body: some View {
        Button(action: {
            onSelect(!isSelected)
        }) {
            Text(genre.name)
                .padding(8)
                .background(isSelected ? Color.orange : Color.black)
                .foregroundColor(isSelected ? .black : .white)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(isSelected ? Color.clear : Color.orange, lineWidth: 2)
                )
        }
    }
}

#Preview {
    FilterChip(genre: Genre(id: 1, name: "h"), isSelected: true, onSelect: {_ in })
}
