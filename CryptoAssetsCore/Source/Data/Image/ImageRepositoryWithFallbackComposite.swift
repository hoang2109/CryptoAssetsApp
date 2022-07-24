//
//  ImageRepositoryWithFallbackComposite.swift
//  CryptoAssetsCore
//
//  Created by Hoang Nguyen on 24/7/22.
//

import Foundation

public class ImageRepositoryWithFallbackComposite: ImageRepository {
    
    public typealias Result = ImageRepository.Result
    
    private class TaskWrapper: Cancellable {
        var wrapped: Cancellable?

        func cancel() {
            wrapped?.cancel()
        }
    }
    
    private let primary: ImageRepository
    private let fallback: ImageRepository
    
    public init(primary: ImageRepository, fallback: ImageRepository) {
        self.primary = primary
        self.fallback = fallback
    }
    
    public func load(_ imageURL: String, completion: @escaping (Result) -> ()) -> Cancellable {
        let task = TaskWrapper()
        task.wrapped = primary.load(imageURL, completion: { [weak self] data in
            guard let self = self else { return }
            if let data = data {
                completion(data)
            } else {
                task.wrapped = self.fallback.load(imageURL, completion: completion)
            }
        })
        return task
    }
}
