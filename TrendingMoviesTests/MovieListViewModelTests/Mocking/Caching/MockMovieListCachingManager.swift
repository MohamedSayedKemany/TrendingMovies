//
//  MockMovieListCachingManager.swift
//  TrendingMoviesTests
//
//  Created by Mohamed Sayed on 02/10/2024.
//

@testable import TrendingMovies

class MockMovieListCachingManager: CachingManager {
    var mockCachedData: MovieResponse?
    
    func save(data: MovieResponse, forKey key: String) {
        mockCachedData = data
    }
    
    func retrieve<T: Codable>(forKey key: String) -> T? {
        if let mockCachedData = mockCachedData as? T {
            return mockCachedData
        }
        return nil
    }
}
