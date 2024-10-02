//
//  MovieListViewModel.swift
//  TrendingMovies
//
//  Created by Mohamed Sayed on 30/09/2024.
//

import Foundation
import Combine

class MovieListViewModel: ObservableObject {
    @Published var movies: [Movie] = []
    @Published var isLoading = false
    @Published var error: Error?
    @Published var searchText = ""
    @Published var selectedGenres: Set<Int> = []
    
    private var currentPage = 1
    private let networkService: NetworkService
    private var cancellables = Set<AnyCancellable>()
    private let cachingManager = CachingManager.shared
    
    var isLoadingMore = false
    var filteredMovies: [Movie] {
        movies.filter { movie in
            (searchText.isEmpty || movie.title.lowercased().contains(searchText.lowercased())) &&
            (selectedGenres.isEmpty || movie.genreIDS.contains(where: { selectedGenres.contains($0) }))
        }
    }
    
    init(networkService: NetworkService = NetworkServiceImpl()) {
        self.networkService = networkService
    }

    func fetchMovies(page: Int) {
        guard !isLoading else { return }
        
        let endpoint = Endpoint(path: "discover/movie",
                                queryItems: [
                                    URLQueryItem(name: "include_adult", value: "false"),
                                    URLQueryItem(name: "page", value: String(page)),
                                    URLQueryItem(name: "sort_by", value: "popularity.desc")
                                ])
        
        if !NetworkMonitor.shared.isConnected {
            if let cachedMovies: [Movie] = cachingManager.retrieve(forKey: "trendingMovies") {
                self.movies = cachedMovies
            }
        } else {
            isLoading = true
            networkService.request(endpoint: endpoint, modelType: MovieResponse.self)
                .receive(on: DispatchQueue.main)
                .handleEvents(receiveCancel: { [weak self] in
                    self?.isLoading = false
                })
                .sink(receiveCompletion: { [weak self] completion in
                    self?.isLoading = false
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        self?.error = error
                    }
                }, receiveValue: { [weak self] movieResponse in
                    guard let self = self else { return }
                    if movieResponse.results != self.movies {
                        self.movies.append(contentsOf: movieResponse.results)
                        self.isLoadingMore = false
                        self.cachingManager.save(data: movieResponse.results, forKey: "trendingMovies")
                    }
                })
                .store(in: &cancellables)
        }
    }
    
    func fetchMoreMovies() {
        guard !isLoadingMore else { return }
        isLoadingMore = true
        currentPage += 1
        fetchMovies(page: currentPage)
    }
    
    deinit {
        cancellables.removeAll()
    }
}
