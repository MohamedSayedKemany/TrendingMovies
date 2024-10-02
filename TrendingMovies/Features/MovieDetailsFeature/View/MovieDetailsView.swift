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
                            .frame(width: UIScreen.main.bounds.width, height: 400)
                    } placeholder: {
                        ProgressView()
                    }
                }
                
                MovieInfoSectionView(movie: viewModel.movie)
                
                MovieDetailsSectionView(movie: viewModel.movie)
                    .padding()
            }
        }
        .background(.black)
    }
}

#Preview {
    MovieDetailsView(viewModel: MovieDetailsViewModel(movieId: 1))
}
