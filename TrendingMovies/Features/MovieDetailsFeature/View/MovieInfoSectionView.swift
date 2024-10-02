//
//  MovieInfoSectionView.swift
//  TrendingMovies
//
//  Created by Mohamed Sayed on 02/10/2024.
//

import SwiftUI

struct MovieInfoSectionView: View {
    let movie: MovieDetails?
    
    var body: some View {
        HStack(alignment: .top) {
            if let posterPath = movie?.posterPath, let imageUrl = URL(string: "\(Constants.imageBaseUrl)\(posterPath)") {
                AsyncImage(url: imageUrl) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 150)
                } placeholder: {
                    ProgressView()
                }
            }
            
            VStack(alignment: .leading) {
                Text(movie?.originalTitle ?? "")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                
                if let genres = movie?.genres {
                    Text("Genres: \(genres.map { $0.name }.joined(separator: ", "))")
                        .font(.subheadline)
                        .foregroundColor(.white)
                }
            }
        }
        
    }
}
