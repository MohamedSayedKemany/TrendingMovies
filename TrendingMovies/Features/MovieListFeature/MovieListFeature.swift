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
    
    init(viewModel: MovieListViewModel, genreViewModel: GenreViewModel ) {
        self.viewModel = viewModel
        self.genreViewModel = genreViewModel
    }
    
    let width = UIScreen.main.bounds.size.width - 50
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    TextField("Search", text: $viewModel.searchText)
                        .textFieldStyle(.roundedBorder)
                        .padding()
                    
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(genreViewModel.genres) { genre in
                                FilterChip(genre: genre, isSelected: viewModel.selectedGenres.contains(genre.id), onSelect: { isSelected in
                                    if isSelected {
                                        viewModel.selectedGenres.insert(genre.id)
                                    } else {
                                        viewModel.selectedGenres.remove(genre.id)
                                    }
                                })
                            }
                        }
                        .padding()
                    }
                    
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: width / 2))]) {
                        ForEach(viewModel.filteredMovies) { movie in
                            NavigationLink(destination: MovieDetailsView(viewModel: MovieDetailsViewModel(movieId: movie.id))) {
                                MovieCellView(movie: movie)
                            }
                        }
                    }
                    .padding()
                }
            }
            .background(Color.white)
            .onAppear {
                if viewModel.movies.isEmpty {
                    viewModel.fetchMovies(page: 1)
                    genreViewModel.fetchGenres()
                }
            }
            .navigationBarTitle("Movies")
        }
    }
}
