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
    
    public init(coinService: CoinService, imageService: ImageService) {
        self.coinService = coinService
        self.imageService = imageService
    }
    
    public func fetchCoinsList() {
        onLoadingChange?(true)
        coinService.fetchCoins { [weak self] result in
            guard let self = self else { return }
            if let coins = try? result.get() {
                let items = coins.map { (item) -> CoinCellController in
                    let cellModel = CoinCellModel(item, imageService: self.imageService)
                    return CoinCellController(cellModel: cellModel)
                }
                self.onCoinChange?(items)
            }
            self.onLoadingChange?(false)
        }
    }
}
