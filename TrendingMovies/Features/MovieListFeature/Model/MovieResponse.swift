//
//  MovieResponse.swift
//  TrendingMovies
//
//  Created by Mohamed Sayed on 30/09/2024.
//

import Foundation

struct MovieResponse: Decodable {
    let results: [Movie]
}
