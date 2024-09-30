//
//  NetworkService.swift
//  TrendingMovies
//
//  Created by Mohamed Sayed on 30/09/2024.
//

import Foundation
import Combine

protocol NetworkService {
    func request<T: Decodable>(endpoint: Endpoint, modelType: T.Type) -> AnyPublisher<T, NetworkError>
}

struct Endpoint {
    let path: String
    let method: HTTPMethod = .get
    var parameters: [String: Any]? = nil
    var queryItems: [URLQueryItem]? = nil
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

enum NetworkError: Error {
    case invalidURL
    case decodingError(Error)
    case networkError(Error)
    case serverError(Int)
}

class NetworkServiceImpl: NetworkService {
    private let apiKey = "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI1Y2Y4OTBiNjIzZTkyMTJjZTAxNDJiZTllMmE3NWJlMCIsIm5iZiI6MTcyNzY4ODc4OC4zNTc3MzIsInN1YiI6IjY2ZmE2ZjcyM2EwZjVhMDhjOGYxODNhZSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.jZxCaAy80Ck5aa36HzbFzQibBbo0Kn4GtfZg8g-cTF0"
    
    func request<T: Decodable>(endpoint: Endpoint, modelType: T.Type) -> AnyPublisher<T, NetworkError> {
        guard let url = URL(string: endpoint.path) else {
            return Fail(error: NetworkError.invalidURL).eraseToAnyPublisher()
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = endpoint.method.rawValue

        if let parameters = endpoint.parameters {
            urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: [])
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        if let queryItems = endpoint.queryItems {
                    var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)!
                    urlComponents.queryItems = queryItems
                    urlRequest.url = urlComponents.url

                }
        
        urlRequest.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")

        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .map {
                $0.data
            }
            .decode(type: modelType.self, decoder: JSONDecoder())
            .mapError { error in
                if let decodingError = error as? DecodingError {
                    return NetworkError.decodingError(decodingError)
                } else if let networkError = error as? URLError {
                    return NetworkError.networkError(networkError)
                } else if let httpResponse = error as? HTTPURLResponse, httpResponse.statusCode >= 400 {
                    return NetworkError.serverError(httpResponse.statusCode)
                } else {
                    return NetworkError.networkError(error)
                }
            }
            .eraseToAnyPublisher()
    }
}
