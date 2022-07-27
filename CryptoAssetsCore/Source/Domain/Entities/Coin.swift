//
//  Coin.swift
//  CryptoAssetsCore
//
//  Created by Hoang Nguyen on 22/7/22.
//

import Foundation

public struct Coin: Equatable {
    public let name: String
    public let code: String
    public let imageURL: String
    public var price: Double
    public let open24Hour: Double
    
    public init(name: String, code: String, imageURL: String, price: Double, open24Hour: Double) {
        self.name = name
        self.code = code
        self.imageURL = imageURL
        self.price = price
        self.open24Hour = open24Hour
    }
    
    public mutating func update(with coinTicker: CoinTicker) {
        if code == coinTicker.code {
            price = coinTicker.price
        }
    }
    
    public func calculatePercentChanged() -> Double {
        let openPrice = open24Hour
        let currPrice = price
        
        let diffPrice = currPrice - openPrice
        let percentage = diffPrice / openPrice
        return percentage
    }
}
