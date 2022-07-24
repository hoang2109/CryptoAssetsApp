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
    public let price: Double
    
    public init(name: String, code: String, imageURL: String, price: Double) {
        self.name = name
        self.code = code
        self.imageURL = imageURL
        self.price = price
    }
}
