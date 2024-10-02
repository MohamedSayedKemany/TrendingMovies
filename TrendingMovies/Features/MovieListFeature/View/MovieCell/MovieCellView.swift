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
                    .aspectRatio(contentMode: .fill)
                    .frame(maxWidth: .infinity)
            } placeholder: {
                ProgressView()
            }

            Text(movie.title)
                .foregroundColor(.white)
                .font(.headline)
                .padding(.top, 4)
                .padding(.leading, 8)
            
            Text(movie.releaseDate)
                .foregroundColor(.white)
                .font(.caption)
                .padding([.top, .bottom], 4)
                .padding(.leading, 8)
        }
//        .padding(8)
        .background(Color.darkGrey)
        .cornerRadius(8)
    }
}
