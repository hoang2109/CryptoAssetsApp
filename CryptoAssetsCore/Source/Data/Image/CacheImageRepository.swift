//
//  CacheImageRepository.swift
//  CryptoAssetsCore
//
//  Created by Hoang Nguyen on 24/7/22.
//

import Foundation

public class CacheImageRepository: ImageRepository {
    public typealias Result = ImageRepository.Result
    
    private let baseURL: URL
    private let cache: URLCache
    
    public init(baseURL: URL, cache: URLCache) {
        self.baseURL = baseURL
        self.cache = cache
    }
    
    public func load(_ imageURL: String, completion: @escaping (Result) -> ()) -> Cancellable {
        let url = baseURL.appendingPathComponent(imageURL)
        let data = cache.get(url)
        completion(data)
        return NoneCancellable()
    }
}
