//
//  CoinTickerMapper.swift
//  CryptoAssetsCore
//
//  Created by Hoang Nguyen on 26/7/22.
//

import Foundation

enum CoinTickerMapper {
    private struct Response: Decodable {
        let PRICE: Double
        let FROMSYMBOL: String
    }
    
    static func map(_ data: Data) throws -> CoinTicker {
        let response = try JSONDecoder().decode(Response.self, from: data)
        return CoinTicker(code: response.FROMSYMBOL, price: response.PRICE)
    }
}
