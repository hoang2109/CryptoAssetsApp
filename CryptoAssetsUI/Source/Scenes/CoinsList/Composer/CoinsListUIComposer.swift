//
//  CoinsListUIComposer.swift
//  CryptoAssetsUI
//
//  Created by Hoang Nguyen on 23/7/22.
//

import Foundation
import UIKit
import CryptoAssetsCore

public final class CoinsListUIComposer {
    private init() {}
    
    public static func coinsListComposedWith(coinService: CoinService, imageService: ImageService) -> CoinsListViewController {
        let viewController = Self.makeCoinsListViewController(title: "CryptoAssets")
        let viewModel = CoinsListViewModel(
            coinService: MainQueueDispatchDecorator(coinService),
            imageService: MainQueueDispatchDecorator(imageService)
        )
        viewController.viewModel = viewModel
        return viewController
    }
    
    private static func makeCoinsListViewController(title: String) -> CoinsListViewController {
        let bundle = Bundle(for: CoinsListViewController.self)
        let storyboard = UIStoryboard(name: "CoinsList", bundle: bundle)
        let feedController = storyboard.instantiateInitialViewController() as! CoinsListViewController
        feedController.title = title
        return feedController
    }
}
