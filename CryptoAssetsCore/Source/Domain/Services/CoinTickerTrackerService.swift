//
//  CoinTickerTrackerService.swift
//  CryptoAssetsCore
//
//  Created by Hoang Nguyen on 24/7/22.
//

import Foundation

public protocol CoinTickerTrackerService {
    func connect()
    func track(coins: [Coin])
    @discardableResult
    func listen(onChange: @escaping (CoinTicker) -> ()) -> Cancellable
}
