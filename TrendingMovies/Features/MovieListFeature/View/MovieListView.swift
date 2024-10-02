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
    
    init(viewModel: MovieListViewModel, genreViewModel: GenreViewModel) {
        self.viewModel = viewModel
        self.genreViewModel = genreViewModel
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    TextField("Search", text: $viewModel.searchText)
                        .textFieldStyle(.roundedBorder)
                        .padding()
                    
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
                        .padding()
                    }
                    
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: UIScreen.main.bounds.size.width / 2 - 5))]) {
                            ForEach(viewModel.filteredMovies) { movie in
                                NavigationLink(destination: MovieDetailsView(viewModel: MovieDetailsViewModel(movieId: movie.id))) {
                                    MovieCellView(movie: movie)
                                }
                            }
                            .onAppear { [weak viewModel] in
                                guard let viewModel else { return }
                                if !viewModel.isLoadingMore {
                                    viewModel.fetchMoreMovies()
                                }
                            }
                        .padding()
                    }
                }
            }
            .background(Color.white)
            .onAppear { [weak viewModel] in
                guard let viewModel else { return }
                if viewModel.movies.isEmpty {
                    viewModel.fetchMovies(page: 1)
                }
                if genreViewModel.genres.isEmpty {
                    genreViewModel.fetchGenres()
                }
            }
            .navigationBarTitle("Movies")
        }
    }
}
