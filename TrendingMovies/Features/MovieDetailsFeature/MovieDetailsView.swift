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

                movieInfoSection
                    .padding()

                movieDetailsSection
                    .padding()

               
            }
            .padding()
        }
    }
    
    private var movieInfoSection: some View {
        HStack {
            if let posterPath = viewModel.movie?.posterPath, let imageUrl = URL(string: "\(Constants.imageBaseUrl)\(posterPath)") {
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
                Text(viewModel.movie?.originalTitle ?? "")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                
                if let genres = viewModel.movie?.genres {
                    Text("Genres: \(genres.map { $0.name }.joined(separator: ", "))")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
        }
    }

    private var movieDetailsSection: some View {
        VStack(alignment: .leading, spacing: 8) {

            if let overview = viewModel.movie?.overview {
                Text(overview)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding(.top, 4)
            }
            
            Spacer()
            
            VStack(alignment: .leading) {
                if let homepage = viewModel.movie?.homepage, let url = URL(string: homepage) {
                    Link("Visit Homepage", destination: url)
                        .font(.subheadline)
                        .foregroundColor(.blue)
                        .padding(.top, 4)
                }
                                
                if let spokenLanguages = viewModel.movie?.spokenLanguages {
                    Text("Spoken Languages: \(spokenLanguages.map { $0.name }.joined(separator: ", "))")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
            
            HStack {
                VStack(alignment: .leading) {
                    if let status = viewModel.movie?.status {
                        Text("Status: \(status)")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    
                    if let budget = viewModel.movie?.budget {
                        Text("Budget:")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        
                        Text(AppUtils.formatCurrency(budget))
                            .font(.subheadline)
                            .bold()
                            .foregroundColor(.gray)
                    }
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    if let runtime = viewModel.movie?.runtime {
                        Text("Runtime: \(runtime) minutes")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    if let revenue = viewModel.movie?.revenue {
                        Text("Revenue:")
                            .font(.footnote)
                            .foregroundColor(.gray)
                        
                        Text(AppUtils.formatCurrency(revenue))
                            .font(.footnote)
                            .foregroundColor(.gray)
                    }
                }
            }
        }
    }
}

#Preview {
    MovieDetailsView(viewModel: MovieDetailsViewModel(movieId: 1))
}
