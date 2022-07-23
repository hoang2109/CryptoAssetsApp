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
    
    var onCoinChange: Observer<[CoinCellModel]>?
    var onLoadingChange: Observer<Bool>?
    
    private let coinService: CoinService
    
    public init(coinService: CoinService) {
        self.coinService = coinService
    }
    
    public func fetchCoinsList() {
        onLoadingChange?(true)
        coinService.fetchCoins { [weak self] result in
            guard let self = self else { return }
            if let coins = try? result.get() {
                let items = coins.map { coin in
                    CoinCellModel(name: coin.name, code: coin.code)
                }
                self.onCoinChange?(items)
            }
            self.onLoadingChange?(false)
        }
    }
}
