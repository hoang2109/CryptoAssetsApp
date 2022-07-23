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
        let coinService = CoinServiceStub()
        let imageService = ImageServiceStub()
        let viewController = CoinsListUIComposer.coinsListComposedWith(coinService: coinService, imageService: imageService)
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

extension UIImage {
    static func make(withColor color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()!
        context.setFillColor(color.cgColor)
        context.fill(rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!
    }
}

