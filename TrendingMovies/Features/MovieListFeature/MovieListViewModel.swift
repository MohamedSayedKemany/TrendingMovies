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

    private let networkService: NetworkService
    private var cancellables = Set<AnyCancellable>()

    var filteredMovies: [Movie] {
        var filteredMovies = movies

        if !searchText.isEmpty {
            filteredMovies = filteredMovies.filter { movie in
                movie.title.lowercased().contains(searchText.lowercased())
            }
        }

        if !selectedGenres.isEmpty {
            filteredMovies = filteredMovies.filter { movie in
                movie.genreIDS.contains(where: { selectedGenres.contains($0) })
            }
        }

        return filteredMovies
    }
    
    init(networkService: NetworkService = NetworkServiceImpl()) {
        self.networkService = networkService
    }

    func fetchMovies(page: Int) {
        let endpoint = Endpoint(path: "https://api.themoviedb.org/3/discover/movie",
                                queryItems: [
                                    URLQueryItem(name: "include_adult", value: "false"),
                                    URLQueryItem(name: "page", value: String(page)),
                                    URLQueryItem(name: "sort_by", value: "popularity.desc")
                                ])

        isLoading = true
        networkService.request(endpoint: endpoint, modelType: MovieResponse.self)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self?.error = error
                }
            }, receiveValue: { [weak self] movies in
                self?.movies.append(contentsOf: movies.results)
            })
            .store(in: &cancellables)
    }
}
