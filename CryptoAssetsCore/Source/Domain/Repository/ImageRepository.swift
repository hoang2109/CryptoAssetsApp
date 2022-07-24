//
//  ImageRepository.swift
//  CryptoAssetsCore
//
//  Created by Hoang Nguyen on 24/7/22.
//

import Foundation

public protocol ImageRepository {
    typealias Result = Data?
    
    func load(_ imageURL: String, completion: @escaping (Result) -> ()) -> Cancellable
}
