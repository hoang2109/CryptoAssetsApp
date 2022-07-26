//
//  TopTierCoinsMapper.swift
//  CryptoAssetsCore
//
//  Created by Hoang Nguyen on 24/7/22.
//

import Foundation

enum TopTierCoinsMapper {
    
    private struct CoinRootResponse: Decodable {
        let data: [CoinResponse]
        
        enum CodingKeys: String, CodingKey {
            case data = "Data"
        }
        
        var coins : [Coin] {
            data.map(\.coin)
        }
    }
    
    private struct CoinResponse: Codable {
        let coinInfo: CoinInfo
        let raw: Raw?
        
        enum CodingKeys : String, CodingKey {
            case coinInfo = "CoinInfo"
            case raw = "RAW"
        }
        
        var coin: Coin {
            Coin(name: coinInfo.fullName, code: coinInfo.name, imageURL: coinInfo.imageURL, price: raw?.usd.price ?? 0, open24Hour: raw?.usd.open24Hour ?? 0)
        }
    }
    
    struct CoinInfo: Codable {
        let name: String
        let fullName: String
        let imageURL: String
        
        private enum CodingKeys : String, CodingKey {
            case name = "Name", fullName = "FullName", imageURL = "ImageUrl"
        }
    }
    
    struct Raw: Codable{
        let usd: USD
        
        private enum CodingKeys: String, CodingKey {
            case usd = "USD"
        }
    }
    
    struct USD: Codable {
        let price: Double
        let open24Hour: Double
        
        private enum CodingKeys: String, CodingKey {
            case price = "PRICE", open24Hour = "OPEN24HOUR"
        }
    }
    
    private static var statusCode200: Int { return 200 }
    
    static func map(data: Data, response: HTTPURLResponse) -> CoinService.Result {
        guard response.statusCode == statusCode200, let data = try? JSONDecoder().decode(CoinRootResponse.self, from: data) else {
            return .failure(RemoteCoinService.Error.invalidData)
        }
        return .success(data.coins)
    }
}
