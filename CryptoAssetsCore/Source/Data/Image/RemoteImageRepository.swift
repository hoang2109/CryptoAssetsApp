//
//  RemoteImageRepository.swift
//  CryptoAssetsCore
//
//  Created by Hoang Nguyen on 24/7/22.
//

import Foundation

public class RemoteImageRepository: ImageRepository {
    public typealias Result = ImageRepository.Result
    
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

extension URL {

    func appending(_ queryItem: String, value: String?) -> URL {

        guard var urlComponents = URLComponents(string: absoluteString) else { return absoluteURL }

        // Create array of existing query items
        var queryItems: [URLQueryItem] = urlComponents.queryItems ??  []

        // Create query item
        let queryItem = URLQueryItem(name: queryItem, value: value)

        // Append the new query item in the existing query items array
        queryItems.append(queryItem)

        // Append updated query items array in the url component object
        urlComponents.queryItems = queryItems

        // Returns the url from new url components
        return urlComponents.url!
    }
}

extension URLSessionDataTask: Cancellable {
}
