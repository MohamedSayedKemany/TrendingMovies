//
//  SceneDelegate.swift
//  TrendingMovies
//
//  Created by Mohamed Sayed on 30/09/2024.
//

import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // UIWindowScene is the first available scene
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(rootView: ContentView())
            self.window = window
            window.makeKeyAndVisible()

            // Set up Core Data
            CachingManager.shared.container.loadPersistentStores { (description, error) in
                if let error = error {
                    fatalError("Unresolved error \(error), \(error.localizedDescription)")
                }
            }
        }
    }
}
