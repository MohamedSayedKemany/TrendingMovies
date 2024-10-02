//
//  MovieListFeature.swift
//  TrendingMovies
//
//  Created by Mohamed Sayed on 30/09/2024.
//

import SwiftUI

struct MovieListView: View {
    @ObservedObject var viewModel: MovieListViewModel
    @ObservedObject var genreViewModel: GenreViewModel
    @StateObject private var router = Router()
    
    init(viewModel: MovieListViewModel, genreViewModel: GenreViewModel) {
        self.viewModel = viewModel
        self.genreViewModel = genreViewModel
    }
    
    var body: some View {
        NavigationStack(path: $router.path) {
            
            VStack {
                
                CustomTextField(text: $viewModel.searchText, placeholder: "Search movies")
                    .padding([.leading, .trailing], 16)
                
                ScrollView(.horizontal) {
                    LazyHStack {
                        ForEach(genreViewModel.genres) { genre in
                            FilterChip(genre: genre, isSelected: viewModel.selectedGenres.contains(genre.id), onSelect: { [weak viewModel] isSelected in
                                if isSelected {
                                    viewModel?.selectedGenres.insert(genre.id)
                                } else {
                                    viewModel?.selectedGenres.remove(genre.id)
                                }
                            })
                        }
                    }
                    .frame(height: 50)
                    .padding([.leading, .trailing], 16)
                    .padding([.top, .bottom], 5)
                    
                }
                
                ScrollView {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: UIScreen.main.bounds.size.width / 2 - 5))]) {
                        ForEach(viewModel.filteredMovies) { movie in
                            Button(action: {
                                router.push(.movieDetails(movie: movie))
                            }) {
                                MovieCellView(movie: movie)
                            }
                            .onAppear { [weak viewModel] in
                                guard let viewModel else { return }
                                if !viewModel.isLoadingMore {
                                    viewModel.fetchMoreMovies()
                                }
                            }
                            
                        }
                        .padding()
                    }
                }
            }
            .background(Color.black)
            .onAppear { [weak viewModel] in
                guard let viewModel else { return }
                if viewModel.movies.isEmpty {
                    viewModel.fetchMovies(page: 1)
                }
                if genreViewModel.genres.isEmpty {
                    genreViewModel.fetchGenres()
                }
            }
            .navigationDestination(for: Route.self) { route in
                switch route {
                case .movieDetails(let movie):
                    MovieDetailsView(viewModel: MovieDetailsViewModel(movieId: movie.id))
                }
            }
        }
    }
}
