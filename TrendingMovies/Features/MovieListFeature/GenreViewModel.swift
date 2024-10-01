//
//  GenreViewModel.swift
//  TrendingMovies
//
//  Created by Mohamed Sayed on 30/09/2024.
//

import Foundation
import Combine

class GenreViewModel: ObservableObject {
    @Published var genres: [Genre] = []
    @Published var error: Error?
    
    private var cancellables = Set<AnyCancellable>()
    private let networkService: NetworkService

    init(networkService: NetworkService = NetworkServiceImpl()) {
        self.networkService = networkService
    }

    func fetchGenres() {
        let endpoint = Endpoint(path: "genre/movie/list")

        networkService.request(endpoint: endpoint, modelType: Genres.self)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.error = error
                }
            }, receiveValue: { genres in
                self.genres = genres.genres
            })
            .store(in: &cancellables)
    }
}
