//
//  SceneDelegate.swift
//  CryptoAssetsApp
//
//  Created by Hoang Nguyen on 22/7/22.
//

import UIKit
import CryptoAssetsCore
import CryptoAssetsUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private lazy var navController = UINavigationController()
    private lazy var urlProvider = AppURLProvider()
    private lazy var httpClient = URLSessionHTTPClient(urlProvider)
    private lazy var urlCache = URLCacheImpl()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)

        navController.setViewControllers([makeCoinsListViewController()], animated: true)
        window.rootViewController = navController

        self.window = window
        self.window?.makeKeyAndVisible()
    }
    
    func makeCoinsListViewController() -> UIViewController {
        let remoteImageService = RemoteImageService(baseURL: urlProvider.imageBaseURL, cache: urlCache)
        let cacheImageService = CacheImageService(baseURL: urlProvider.imageBaseURL, cache: urlCache)
        let imageService = ImageServiceWithFallbackComposite(primary: cacheImageService, fallback: remoteImageService)
        let coinService = RemoteCoinService(httpClient)
        let coinTickerTrackerService = CoinTickerTrackerServiceImpl(url: urlProvider.webSocketBaseURL)
        let viewController = CoinsListUIComposer.coinsListComposedWith(coinService: coinService, imageService: imageService, coinTickerTrackerService: coinTickerTrackerService)
        return viewController
    }
}
