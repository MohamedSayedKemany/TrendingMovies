//
//  MockGenresNetworkService.swift
//  TrendingMoviesTests
//
//  Created by Mohamed Sayed on 02/10/2024.
//

import Combine
@testable import TrendingMovies

class MockGenresNetworkService: NetworkService {
    
    var mockResponse: Genres?
    var mockError: NetworkError?

    func request<T>(endpoint: TrendingMovies.Endpoint, modelType: T.Type) -> AnyPublisher<T, TrendingMovies.NetworkError> where T : Decodable {
        if let mockError = mockError {
            return Fail(error: mockError).eraseToAnyPublisher()
        } else if let mockResponse = mockResponse {
            return Just(mockResponse as! T)
                .setFailureType(to: NetworkError.self)
                .eraseToAnyPublisher()
        } else {
            return Fail(error: NetworkError.invalidURL).eraseToAnyPublisher()
        }
    }
}
