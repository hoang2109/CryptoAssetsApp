//
//  AppURLProvider.swift
//  CryptoAssetsApp
//
//  Created by Hoang Nguyen on 27/7/22.
//

import Foundation
import CryptoAssetsCore

struct AppURLProvider: BaseURLProvider {
    var apiBaseURL: URL {
        return URL(string: "https://min-api.cryptocompare.com")!
    }
    
    var imageBaseURL: URL {
        return URL(string: "https://www.cryptocompare.com")!
    }
    
    var webSocketBaseURL: URL {
        return URL(string: "wss://streamer.cryptocompare.com/v2?api_key=4c6ec4fa84b66963743a2a2ea291ec5e6216fe1c5453046f3b16c186878743b5")!
    }
}
