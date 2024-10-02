//
//  MovieDetailsSectionView.swift
//  TrendingMovies
//
//  Created by Mohamed Sayed on 02/10/2024.
//

import SwiftUI

struct MovieDetailsSectionView: View {
    let movie: MovieDetails?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            
            if let overview = movie?.overview {
                Text(overview)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding(.top, 4)
            }
            
            Spacer()
            
            VStack(alignment: .leading) {
                if let homepage = movie?.homepage, let url = URL(string: homepage) {
                    Link("Visit Homepage", destination: url)
                        .font(.subheadline)
                        .foregroundColor(.blue)
                        .padding(.top, 4)
                }
                
                if let spokenLanguages = movie?.spokenLanguages {
                    Text("Spoken Languages: \(spokenLanguages.map { $0.name }.joined(separator: ", "))")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
            
            HStack {
                VStack(alignment: .leading) {
                    if let status = movie?.status {
                        Text("Status: \(status)")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    
                    if let budget = movie?.budget {
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
                    if let runtime = movie?.runtime {
                        Text("Runtime: \(runtime) minutes")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    if let revenue = movie?.revenue {
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
