//
//  URLCache.swift
//  CryptoAssetsCore
//
//  Created by Hoang Nguyen on 24/7/22.
//

import Foundation

public protocol URLCache {
    func get(_ key: URL) -> Data?
    func set(_ key: URL, newValue: Data?)
}

public struct URLCacheImpl: URLCache {
    let cache = NSCache<NSURL, NSData>()

    public init() {}
    
    public func get(_ key: URL) -> Data? {
        guard let data = cache.object(forKey: key as NSURL) else {
            return nil
        }
        return Data(referencing: data)
    }
    
    public func set(_ key: URL, newValue: Data?) {
        if let newValue = newValue {
            cache.setObject(NSData(data: newValue), forKey: key as NSURL)
        } else {
            cache.removeObject(forKey: key as NSURL)
        }
    }
}
