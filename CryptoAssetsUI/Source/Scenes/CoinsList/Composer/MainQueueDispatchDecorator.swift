//
//  MainQueueDispatchDecorator.swift
//  CryptoAssetsUI
//
//  Created by Hoang Nguyen on 23/7/22.
//

import Foundation
import CryptoAssetsCore

class MainQueueDispatchDecorator<T> {
    private let decoratee: T
    
    init(_ decoratee: T) {
        self.decoratee = decoratee
    }
    
    func dispathMainThread(_ completion: @escaping () -> ()) {
        guard Thread.isMainThread else {
            return DispatchQueue.main.async(execute: completion)
        }

        completion()
    }
}

extension MainQueueDispatchDecorator: CoinService where T == CoinService {
    func fetchCoins(_ completion: @escaping (CoinService.Result) -> ()) {
        decoratee.fetchCoins { [weak self] result in
            self?.dispathMainThread {
                completion(result)
            }
        }
    }
}

extension MainQueueDispatchDecorator: ImageService where T == ImageService {
    func load(_ imageURL: String, completion: @escaping (ImageService.Result) -> ()) -> Cancellable {
        decoratee.load(imageURL) { [weak self] result in
            self?.dispathMainThread {
                completion(result)
            }
        }
    }
}
