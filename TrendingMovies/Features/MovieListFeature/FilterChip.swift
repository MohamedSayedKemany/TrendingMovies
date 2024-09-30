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
                .foregroundColor(isSelected ? .white : .black)
                .background(isSelected ? Color.blue : Color.gray)
                .cornerRadius(8)
        }
    }
}

#Preview {
    FilterChip(genre: Genre(id: 1, name: "h"), isSelected: true, onSelect: {_ in })
}
