//
//  ContentView.swift
//  TrendingMovies
//
//  Created by Mohamed Sayed on 30/09/2024.
//

import SwiftUI

struct ContentView: View {
    @State private var showSplashScreen = true
    
    var body: some View {
        ZStack {
            if showSplashScreen {
                SplashScreen()
                    .transition(.opacity)
            } else {
                MovieListView(
                    viewModel: MovieListViewModel(),
                    genreViewModel: GenreViewModel()
                )
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation(.easeInOut(duration: 0.5)) {
                    showSplashScreen = false
                }
            }
        }
    }
        
}


#Preview {
    ContentView()
}
