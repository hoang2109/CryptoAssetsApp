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

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)

        navController.setViewControllers([makeCoinsListViewController()], animated: true)
        window.rootViewController = navController

        self.window = window
        self.window?.makeKeyAndVisible()
    }
    
    func makeCoinsListViewController() -> UIViewController {
        let service = CoinServiceStub()        
        let viewController = CoinsListUIComposer.coinsListComposedWith(coinService: service)
        return viewController
    }
    
    
    private class CoinServiceStub: CoinService {
        var stubItem: [Coin] = [
            Coin(name: "Bitcoin", code: "BTC", imageURL: "bitcoin"),
            Coin(name: "Etherium", code: "ETH", imageURL: "ehter"),
            Coin(name: "Ripple", code: "XRP", imageURL: "ripple")
        ]
        
        func fetchCoins(_ completion: @escaping (CoinService.Result) -> ()) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                completion(.success(self.stubItem))
            }
        }
    }
}

