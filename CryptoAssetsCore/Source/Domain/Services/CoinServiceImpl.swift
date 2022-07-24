//
//  CoinServiceImpl.swift
//  CryptoAssetsCore
//
//  Created by Hoang Nguyen on 24/7/22.
//

import Foundation

public class CoinServiceImpl: CoinService {
    private let coinRepository: CoinRepository
    
    public init(_ coinRepository: CoinRepository) {
        self.coinRepository = coinRepository
    }
    
    public func fetchCoins(_ completion: @escaping (CoinService.Result) -> ()) {
        coinRepository.fetchCoins(completion)
    }
}
