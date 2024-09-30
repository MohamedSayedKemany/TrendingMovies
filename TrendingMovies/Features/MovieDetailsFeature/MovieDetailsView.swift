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
                    AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w500/\(viewModel.movie?.posterPath ?? "")")!) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: .infinity, maxHeight: UIScreen.main.bounds.height / 3)
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(maxWidth: .infinity)
                    
                    HStack {
                        VStack(alignment: .leading) {
                            Text(viewModel.movie?.title ?? "")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            Text("Genres: \(viewModel.movie?.genres.map { $0.name }.joined(separator: ", ") ?? "")")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        Spacer()
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                        Text(String(format: "%.1f", viewModel.movie?.voteAverage ?? 0))
                    }
                    .padding()
                    
                    // Release Date
                    Text("Release Date: \(extractYearAndMonth(from: viewModel.movie?.releaseDate ?? ""))")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    // Overview
                    Text(viewModel.movie?.overview ?? "")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .padding(.top, 4)
                    
                    // Homepage
                    if let homepage = viewModel.movie?.homepage {
                        Link("Visit Homepage", destination: URL(string: homepage)!)
                            .font(.subheadline)
                            .foregroundColor(.blue)
                            .padding(.top, 4)
                    }
                    
                    // Budget and Revenue
                    HStack {
                        Text("Budget:")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        Text(formatCurrency(viewModel.movie?.budget))
                            .font(.subheadline)
                            .bold()
                            .foregroundColor(.white)
                        Spacer()
                        Text("Revenue:")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        Text(formatCurrency(viewModel.movie?.revenue))
                            .font(.subheadline)
                            .bold()
                            .foregroundColor(.white)
                    }
                    .padding(.top, 4)
                    
                    // Spoken Languages
                    if let spokenLanguages = viewModel.movie?.spokenLanguages {
                        Text("Spoken Languages: \(spokenLanguages.map { $0.name }.joined(separator: ", "))")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .padding(.top, 4)
                    }
                    
                    // Status
                    Text("Status: \(viewModel.movie?.status ?? "")")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .padding(.top, 4)
                    
                    // Runtime
                    Text("Runtime: \(viewModel.movie?.runtime ?? 0) minutes")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .padding(.top, 4)
                }
                               
                .onAppear {
                    viewModel.fetchMovieDetails(movieId: viewModel.movieId)
                }
                .padding()
            }
            .navigationBarTitle(viewModel.movie?.title ?? "")
        }
    
    func extractYearAndMonth(from dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd" // Adjust format if necessary
        guard let date = dateFormatter.date(from: dateString) else { return "" }

        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let monthFormatter = DateFormatter()
        monthFormatter.dateFormat = "MMMM" // Format month name as desired
        let monthName = monthFormatter.string(from: date)

        return "\(monthName) \(year)"
    }
    
    private func formatCurrency(_ amount: Int?) -> String {
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            formatter.locale = Locale(identifier: "en_US")
     // Adjust locale as needed
            return formatter.string(from: NSNumber(value: amount ?? 0)) ?? ""
        }
}

#Preview {
    MovieDetailsView(viewModel: MovieDetailsViewModel(movieId: 1))
}
