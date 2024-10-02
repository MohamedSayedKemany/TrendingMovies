//
//  Router.swift
//  TrendingMovies
//
//  Created by Mohamed Sayed on 02/10/2024.
//

import SwiftUI

enum Route: Hashable {
    case movieDetails(movie: Movie)
}


class Router: ObservableObject {
    @Published var path: [Route] = []

    func push(_ route: Route) {
        path.append(route)
    }

    func pop() {
        path.removeLast()
    }

    func popToRoot() {
        path.removeAll()
    }
}
