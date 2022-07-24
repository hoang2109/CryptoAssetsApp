//
//  CoinRepository.swift
//  CryptoAssetsCore
//
//  Created by Hoang Nguyen on 24/7/22.
//

import Foundation

public protocol CoinRepository {
    typealias Result = Swift.Result<[Coin], Error>
    
    func fetchCoins(_ completion: @escaping (Result) -> ())
}
