//
//  CoinsListEndpoint.swift
//  CryptoAssetsCore
//
//  Created by Hoang Nguyen on 24/7/22.
//

import Foundation

public enum TopTierCoinsEndpoint {
    public static func request(limit: UInt) -> HTTPRequest {
        HTTPRequest(
            method: .get,
            endPoint: "/data/top/totaltoptiervolfull"
        ).parameters(["limit": "\(limit)",
                      "tsym": "USD"])
    }
}
