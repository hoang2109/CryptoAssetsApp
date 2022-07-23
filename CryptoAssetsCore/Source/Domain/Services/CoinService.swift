//
//  CoinService.swift
//  CryptoAssetsCore
//
//  Created by Hoang Nguyen on 23/7/22.
//

import Foundation

public protocol CoinService {
    typealias Result = Swift.Result<[Coin], Error>
    
    func fetchCoins(_ completion: @escaping (Result) -> ())
}
