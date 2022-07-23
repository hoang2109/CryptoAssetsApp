//
//  CoinCellModel.swift
//  CryptoAssetsUI
//
//  Created by Hoang Nguyen on 23/7/22.
//

import Foundation
import CryptoAssetsCore

class CoinCellModel {
    private let coin: Coin
    
    var name: String {
        coin.name
    }
    
    var code: String {
        coin.code
    }
    
    init(_ coin: Coin) {
        self.coin = coin
    }
}
