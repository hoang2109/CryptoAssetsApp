//
//  CoinTicker.swift
//  CryptoAssetsCore
//
//  Created by Hoang Nguyen on 24/7/22.
//

import Foundation

public struct CoinTicker {
    public let code: String
    public let price: Double
    
    public init(code: String, price: Double) {
        self.code = code
        self.price = price
    }
}
