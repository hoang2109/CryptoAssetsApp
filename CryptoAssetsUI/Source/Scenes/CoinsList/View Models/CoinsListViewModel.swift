//
//  CoinsListViewModel.swift
//  CryptoAssetsUI
//
//  Created by Hoang Nguyen on 23/7/22.
//

import Foundation
import CryptoAssetsCore

public final class CoinsListViewModel {
    typealias Observer<T> = (T) -> ()
    
    var onCoinChange: Observer<[CoinCellController]>?
    var onLoadingChange: Observer<Bool>?
    
    private let coinService: CoinService
    private let imageService: ImageService
    private let coinTickerTrackerService: CoinTickerTrackerService
    
    public init(
        coinService: CoinService,
        imageService: ImageService,
        coinTickerTrackerService: CoinTickerTrackerService
    ) {
        self.coinService = coinService
        self.imageService = imageService
        self.coinTickerTrackerService = coinTickerTrackerService
    }
    
    public func startup() {
        coinTickerTrackerService.connect()
    }
    
    public func fetchCoinsList() {
        onLoadingChange?(true)
        coinService.fetchCoins { [weak self] result in
            guard let self = self, let coins = try? result.get() else { return }
            self.track(coins: coins)
            let items = coins.map(self.map(coin:))
            self.onCoinChange?(items)
            self.onLoadingChange?(false)
        }
    }
    
    private func track(coins: [Coin]) {
        coinTickerTrackerService.track(coins: coins)
    }
    
    private func map(coin: Coin) -> CoinCellController {
        let cellModel = CoinCellModel(coin,
                                      imageService: imageService,
                                      coinTickerTrackerService: coinTickerTrackerService)
        return CoinCellController(cellModel: cellModel)
    }
}
