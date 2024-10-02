//
//  SplashScreen.swift
//  TrendingMovies
//
//  Created by Mohamed Sayed on 30/09/2024.
//

import SwiftUI

struct SplashScreen: View {
    var body: some View {
        VStack {
            Image("splash") 
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: .infinity)
        }
    }
}

#Preview {
    SplashScreen()
}
