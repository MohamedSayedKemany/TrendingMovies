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
            AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w500/\(movie.posterPath)")!) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: .infinity)
            } placeholder: {
                ProgressView()
            }
            .frame(maxWidth: .infinity)

            Text(movie.title)
                .font(.headline)
                .padding(.top, 4)
            
            Text(movie.releaseDate)
                .font(.caption)
                .padding(.top, 4)
        }
        .padding(8)
        .background(Color.gray)
        .cornerRadius(8)
    }
}

#Preview {
    MovieCellView(movie: Movie(adult: true, backdropPath: "", genreIDS: [], id: 33, originalLanguage: .en, originalTitle: "", overview: "", popularity: 3.4, posterPath: "", releaseDate: "2/2/1995", title: "batman", video: false, voteAverage: 6.5, voteCount: 6))
}
