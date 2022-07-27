//
//  CoinCellController.swift
//  CryptoAssetsUI
//
//  Created by Hoang Nguyen on 23/7/22.
//

import Foundation
import UIKit

public final class CoinCellController {
    private let cellModel: CoinCellModel
    private var cell: CoinCell?
    
    init(cellModel: CoinCellModel) {
        self.cellModel = cellModel
    }
    
    func cellForTableView(_ tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        let cell: CoinCell = bind(tableView.dequeueReusableCell())
        cellModel.onCellDidLoaded()
        return cell
    }
    
    func endDisplayingCell() {
        releaseCellForReuse()
        cellModel.endDisplayingCell()
    }
    
    func preloadImage() {
        cellModel.loadImage()
    }
    
    func cancelLoadImage() {
        cellModel.cancelLoadImage()
    }
    
    private func bind(_ cell: CoinCell) -> CoinCell {
        self.cell = cell
        cell.configure(cellModel)
        
        cellModel.onImageLoaded = { [weak self] data in
            guard let self = self else { return }
            self.cell?.setImage(data)
        }
        
        cellModel.onCoinPriceChanged = { [weak self] in
            guard let self = self else { return }
            self.cell?.configure(self.cellModel)
        }
        
        return cell
    }
    
    private func releaseCellForReuse() {
        cell = nil
    }
}
