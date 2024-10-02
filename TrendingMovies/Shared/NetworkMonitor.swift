//
//  NetworkReachability.swift
//  TrendingMovies
//
//  Created by Mohamed Sayed on 01/10/2024.
//

import Foundation
import Network
import Combine

class NetworkMonitor: ObservableObject {
    static var shared: NetworkMonitor = .init()
    let monitor = NWPathMonitor()
    let queue = DispatchQueue(label: "NetworkMonitor")
    @Published var isConnected = true
    
    private var state: NetworkState = .online

    private init() {
        monitor.pathUpdateHandler = { path in
            DispatchQueue.main.async { [weak self] in
                let isNetworkConnected = path.status == .satisfied
                self?.isConnected = isNetworkConnected
                let network: NetworkState = isNetworkConnected ? .online : .offline
                self?.didChangeNetworkReachability(network)
            }
        }
        monitor.start(queue: queue)
    }
    
    private func didChangeNetworkReachability(_ network: NetworkState) {
        guard state != network else { return }
        state = network
    }
}

enum NetworkState {
    case online
    case offline
    
    var tittle: String {
        switch self {
        case .online:
            return "connected"
            
        case .offline:
            return "disconnected"
        }
    }
}
