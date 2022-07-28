//
//  RemoteCoinRepository.swift
//  CryptoAssetsCore
//
//  Created by Hoang Nguyen on 24/7/22.
//

import Foundation

public class RemoteCoinService: CoinService {
    
    public typealias Result = CoinService.Result
    
    private let httpClient: HTTPClient
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    public init(_ httpClient: HTTPClient) {
        self.httpClient = httpClient
    }
    
    public func fetchCoins(_ completion: @escaping (Result) -> ()) {
        let request = TopTierCoinsEndpoint.request(limit: 50)
        httpClient.fetch(request) { [weak self] result in
            guard self != nil else { return }
            switch result {
            case let .success((data, response)):
                completion(TopTierCoinsMapper.map(data: data, response: response))
            case .failure:
                completion(.failure(Error.connectivity))
            }
        }
    }
}
