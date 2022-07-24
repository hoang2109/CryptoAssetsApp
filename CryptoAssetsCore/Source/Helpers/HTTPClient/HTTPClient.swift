//
//  HTTPManager.swift
//  CryptoAssetsCore
//
//  Created by Hoang Nguyen on 24/7/22.
//

import Foundation

public protocol HTTPClient {
    typealias Result = Swift.Result<(Data, HTTPURLResponse), Error>
    
    @discardableResult
    func fetch(_ request: HTTPRequest, completion: @escaping (Result) -> Void) -> Cancellable
}
