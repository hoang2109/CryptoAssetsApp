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
    
    func cellForTableView(_ tableView: UITableView) -> UITableViewCell {
        let cell: CoinCell = bind(tableView.dequeueReusableCell())
        cellModel.loadImage()
        return cell
    }
    
    func preload() {
        cellModel.loadImage()
    }
    
    func cancelLoad() {
        cellModel.cancelLoadImage()
    }
    
    private func bind(_ cell: CoinCell) -> CoinCell {
        self.cell = cell
        cell.nameLabel.text = cellModel.name
        cell.codeLabel.text = cellModel.code
        
        cellModel.onImageLoaded = { [weak self] data in
            guard let self = self else { return }
            self.cell?.iconImageView.setImageAnimated(UIImage(data: data))
        }
        
        return cell
    }
    
    private func releaseCellForReuse() {
        cell = nil
    }
}
