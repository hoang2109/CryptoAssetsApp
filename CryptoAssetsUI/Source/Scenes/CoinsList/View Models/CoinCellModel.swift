//
//  CoinCellModel.swift
//  CryptoAssetsUI
//
//  Created by Hoang Nguyen on 23/7/22.
//

import Foundation
import CryptoAssetsCore

class CoinCellModel {
    
    typealias Observer<T> = (T) -> ()
    
    private let coin: Coin
    private let imageService: ImageService
    private var loadImageTask: Cancellable?
    
    var onLoadingChanged: Observer<Bool>?
    var onImageLoaded: Observer<Data>?
    
    var name: String {
        coin.name
    }
    
    var code: String {
        coin.code
    }
    
    init(_ coin: Coin, imageService: ImageService) {
        self.coin = coin
        self.imageService = imageService
    }
    
    func loadImage() {
        onLoadingChanged?(true)
        loadImageTask = imageService.load(coin.imageURL) { [weak self] result in
            guard let self = self else { return }
            self.onLoadingChanged?(false)
            
            if let data = try? result.get() {
                self.onImageLoaded?(data)
            }
        }
    }
    
    func cancelLoadImage() {
        loadImageTask?.cancel()
        loadImageTask = nil
    }
}
