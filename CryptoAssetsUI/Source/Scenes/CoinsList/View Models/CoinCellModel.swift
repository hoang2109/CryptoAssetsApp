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
    
    enum ChangedType {
        case increase
        case decrease
        case noChanged
    }
    
    var onLoadingChanged: Observer<Bool>?
    var onImageLoaded: Observer<Data>?
    var onCoinPriceChanged: (() -> ())?
    
    private(set) var coin: Coin
    private let imageService: ImageService
    private let coinTickerTrackerService: CoinTickerTrackerService
    
    private var trackerTask: Cancellable?
    private var loadImageTask: Cancellable?
    
    var name: String {
        coin.name
    }
    
    var code: String {
        coin.code
    }
    
    var price: String {
        coin.price.currencyFormat
    }
    
    var changePercentage: String {
        let percentage = coin.calculatePercentChanged()
        return percentage.percentageFormat
    }
    
    var changeType: ChangedType {
        let percentage = coin.calculatePercentChanged()
        if percentage.sign == .plus {
            return percentage == 0 ? .noChanged : .increase
        }
        return .decrease
    }
    
    init(_ coin: Coin,
         imageService: ImageService,
         coinTickerTrackerService: CoinTickerTrackerService) {
        self.coin = coin
        self.imageService = imageService
        self.coinTickerTrackerService = coinTickerTrackerService
    }
    
    func onCellDidLoaded() {
        loadImage()
        listenCoinTickerTrackerService()
    }
    
    func loadImage() {
        onLoadingChanged?(true)
        loadImageTask = imageService.load(coin.imageURL) { [weak self] result in
            guard let self = self else { return }
            self.onLoadingChanged?(false)
            
            if let data = result {
                self.onImageLoaded?(data)
            }
        }
    }
    
    func cancelLoadImage() {
        loadImageTask?.cancel()
        loadImageTask = nil
    }
    
    func endDisplayingCell() {
        cancelLoadImage()
        cancelListenCoinTracker()
    }
    
    deinit {
        endDisplayingCell()
    }
    
    private func listenCoinTickerTrackerService() {
        trackerTask = coinTickerTrackerService.listen(onChange: { [weak self] coinTicker in
            guard let self = self else { return }
            if coinTicker.code == self.coin.code {
                self.coin.update(with: coinTicker)
                self.onCoinPriceChanged?()
            }
        })
    }
    
    private func cancelListenCoinTracker() {
        trackerTask?.cancel()
        trackerTask = nil
    }
}
