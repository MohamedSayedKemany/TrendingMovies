//
//  MovieDetailsView.swift
//  TrendingMovies
//
//  Created by Mohamed Sayed on 30/09/2024.
//

import SwiftUI

struct MovieDetailsView: View {
    @ObservedObject var viewModel: MovieDetailsViewModel
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                if let posterPath = viewModel.movie?.posterPath, let imageUrl = URL(string: "\(Constants.imageBaseUrl)\(posterPath)") {
                    AsyncImage(url: imageUrl) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: .infinity, maxHeight: UIScreen.main.bounds.height / 3)
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(maxWidth: .infinity)
                }
                
                MovieInfoSectionView(movie: viewModel.movie)
                    .padding()
                
                MovieDetailsSectionView(movie: viewModel.movie)
                    .padding()
            }
            .padding()
        }
    }
}

#Preview {
    MovieDetailsView(viewModel: MovieDetailsViewModel(movieId: 1))
}
