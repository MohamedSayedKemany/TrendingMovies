//
//  MovieDetailsViewModel.swift
//  TrendingMovies
//
//  Created by Mohamed Sayed on 30/09/2024.
//

import Foundation
import Combine

class MovieDetailsViewModel: ObservableObject {
    @Published var movie: MovieDetails?
    @Published var isLoading = false
    @Published var error: Error?
    
    private let networkService: NetworkService
    private let cachingManager: CachingManager
    private var cancellables = Set<AnyCancellable>()
    let movieId: Int
    
    init(networkService: NetworkService = NetworkServiceImpl(), cachingManager: CachingManager = CachingManager.shared, movieId: Int) {
        self.networkService = networkService
        self.cachingManager = cachingManager
        self.movieId = movieId
    }
    
    func fetchMovieDetails(movieId: Int) {
        let endpoint = Endpoint(path: "https://api.themoviedb.org/3/movie/\(movieId)")
        
        isLoading = true
        networkService.request(endpoint: endpoint, modelType: MovieDetails.self)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    
                    self?.error = error
                }
            }, receiveValue: { [weak self] movie in
                self?.movie = movie
                self?.cachingManager.save(data: movie, forKey: "movieDetails_\(movieId)")
            })
            .store(in: &cancellables)
    }
}
