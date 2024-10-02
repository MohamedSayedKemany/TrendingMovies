//
//  Movie.swift
//  TrendingMovies
//
//  Created by Mohamed Sayed on 30/09/2024.
//

import Foundation

// MARK: - Movie
struct Movie: Codable, Identifiable, Equatable, Hashable {
    let adult: Bool?
    let backdropPath: String?
    let genreIDS: [Int]
    let id: Int
    let originalTitle, overview: String?
    let popularity: Double?
    let posterPath, releaseDate, title: String
    let video: Bool?
    let voteAverage: Double?
    let voteCount: Int
    
    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case genreIDS = "genre_ids"
        case id
        case originalTitle = "original_title"
        case overview, popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title, video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(adult, forKey: .adult)
        try container.encode(backdropPath, forKey: .backdropPath)
        try container.encode(genreIDS, forKey: .genreIDS)
        try container.encode(id, forKey: .id)
        try container.encode(originalTitle, forKey: .originalTitle)
        try container.encode(overview, forKey: .overview)
        try container.encode(popularity, forKey: .popularity)
        try container.encode(posterPath, forKey: .posterPath)
        try container.encode(releaseDate, forKey: .releaseDate)
        try container.encode(title, forKey: .title)
        try container.encode(video, forKey: .video)
        try container.encode(voteAverage, forKey: .voteAverage)
        try container.encode(voteCount, forKey: .voteCount)
    }

//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        adult = try values.decodeIfPresent(Bool.self, forKey: .adult)
//        backdropPath = try values.decodeIfPresent(String.self, forKey: .backdropPath)
//        genreIDS = try values.decode([Int].self, forKey: .genreIDS)
//        id = try values.decodeIfPresent(Int.self, forKey: .id)!
//        originalTitle = try values.decodeIfPresent(String.self, forKey: .originalTitle)
//        overview = try values.decodeIfPresent(String.self, forKey: .overview)
//        popularity = try values.decodeIfPresent(Double.self, forKey: .popularity)
//        posterPath = try values.decode(String.self, forKey: .posterPath)
//        releaseDate = try values.decode(String.self, forKey: .releaseDate)
//        title = try values.decode(String.self, forKey: .title)
//        video = try values.decodeIfPresent(Bool.self, forKey: .video)
//        voteAverage = try values.decodeIfPresent(Double.self, forKey: .voteAverage)
//        voteCount = try values.decodeIfPresent(Int.self, forKey: .voteCount) ?? 0
//    }
}
