//
//  RemoteImageRepository.swift
//  CryptoAssetsCore
//
//  Created by Hoang Nguyen on 24/7/22.
//

import Foundation

public class RemoteImageService: ImageService {
    public typealias Result = ImageService.Result
    
    private var baseURL: URL
    private let cache: URLCache
    
    public init(baseURL: URL, cache: URLCache) {
        self.baseURL = baseURL
        self.cache = cache
    }
    
    public func load(_ imageURL: String, completion: @escaping (Result) -> ()) -> Cancellable {
        let url = baseURL.appendingPathComponent(imageURL)
        
        let task = URLSession.shared.dataTask(with: url.appending("width", value: "200")) { [weak self] data, response, error in
            guard let self = self else { return }
            self.cache.set(url, newValue: data)
            completion(data)
        }
        task.resume()
        
        return task
    }
}

extension URLSessionDataTask: Cancellable {
}
