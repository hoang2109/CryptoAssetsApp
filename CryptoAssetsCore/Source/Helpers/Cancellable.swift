//
//  Cancellable.swift
//  CryptoAssetsCore
//
//  Created by Hoang Nguyen on 23/7/22.
//

import Foundation

public protocol Cancellable {
    func cancel()
}

public class NoneCancellable: Cancellable {
    public init() {}
    
    public func cancel() { }
}
