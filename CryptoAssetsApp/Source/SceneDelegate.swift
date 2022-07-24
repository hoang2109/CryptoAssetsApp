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
    private lazy var httpClient = URLSessionHTTPClient(APIBaseURLProvider())

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)

        navController.setViewControllers([makeCoinsListViewController()], animated: true)
        window.rootViewController = navController

        self.window = window
        self.window?.makeKeyAndVisible()
    }
    
    func makeCoinsListViewController() -> UIViewController {
        let coinRepository = RemoteCoinRepository(httpClient)
        let coinService = CoinServiceImpl(coinRepository)
        let imageService = ImageServiceStub()
        let viewController = CoinsListUIComposer.coinsListComposedWith(coinService: coinService, imageService: imageService)
        return viewController
    }
    
    private class ImageTask: Cancellable {
        func cancel() {
            
        }
    }
    
    private class ImageServiceStub: ImageService {
        func load(_ imageURL: String, completion: @escaping (ImageService.Result) -> ()) -> Cancellable {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                completion(.success(UIImage.make(withColor: .blue, size: CGSize(width: 30, height: 30)).pngData()!))
            }
            return ImageTask()
        }
    }
}

struct APIBaseURLProvider: BaseURLProvider {
    var baseURL: URL {
        return URL(string: "https://min-api.cryptocompare.com")!
    }
}
