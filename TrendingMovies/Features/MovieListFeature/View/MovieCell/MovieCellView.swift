//
//  MovieCellView.swift
//  TrendingMovies
//
//  Created by Mohamed Sayed on 30/09/2024.
//

import SwiftUI

struct MovieCellView: View {
    let movie: Movie

    var body: some View {
        VStack(alignment: .leading) {
            AsyncImage(url: URL(string: "\(Constants.imageBaseUrl)\(movie.posterPath)")!) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: .infinity)
            } placeholder: {
                ProgressView()
            }
            .frame(maxWidth: .infinity)

            Text(movie.title)
                .foregroundColor(.black)
                .font(.headline)
                .padding(.top, 4)
            
            Text(movie.releaseDate)
                .foregroundColor(.black)
                .font(.caption)
                .padding(.top, 4)
        }
        .padding(8)
        .background(Color.gray)
        .cornerRadius(8)
    }
}
