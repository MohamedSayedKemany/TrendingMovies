//
//  Genre.swift
//  TrendingMovies
//
//  Created by Mohamed Sayed on 30/09/2024.
//


struct Genres: Decodable {
    let genres: [Genre]
}

struct Genre: Codable, Identifiable {
    let id: Int
    let name: String
}
