//
//  BaseURLProvider.swift
//  CryptoAssetsCore
//
//  Created by Hoang Nguyen on 24/7/22.
//

import Foundation

public protocol BaseURLProvider {
    var apiBaseURL: URL { get }
    var imageBaseURL: URL { get }
    var webSocketBaseURL: URL { get }
}
