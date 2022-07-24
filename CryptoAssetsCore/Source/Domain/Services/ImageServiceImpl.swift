//
//  ImageServiceImpl.swift
//  CryptoAssetsCore
//
//  Created by Hoang Nguyen on 24/7/22.
//

import Foundation

public class ImageServiceImpl: ImageService {
    public typealias Result = ImageService.Result
    
    private let imageRepository: ImageRepository
    
    public init(_ imageRepository: ImageRepository) {
        self.imageRepository = imageRepository
    }
    
    public func load(_ imageURL: String, completion: @escaping (Result) -> ()) -> Cancellable {
        return imageRepository.load(imageURL, completion: completion)
    }
}
