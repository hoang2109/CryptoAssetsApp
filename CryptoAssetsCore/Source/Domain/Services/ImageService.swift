//
//  ImageService.swift
//  CryptoAssetsCore
//
//  Created by Hoang Nguyen on 23/7/22.
//

import Foundation

public protocol ImageService {
    typealias Result = Data?
    
    func load(_ imageURL: String, completion: @escaping (Result) -> ()) -> Cancellable
}
