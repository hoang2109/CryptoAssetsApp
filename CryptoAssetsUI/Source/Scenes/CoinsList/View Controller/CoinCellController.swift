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
    
    init(cellModel: CoinCellModel) {
        self.cellModel = cellModel
    }
    
    func cellForTableView(_ tableView: UITableView) -> UITableViewCell {
        let cell: CoinCell = bind(tableView.dequeueReusableCell())
        return cell
    }
    
    private func bind(_ cell: CoinCell) -> CoinCell {
        cell.nameLabel.text = cellModel.name
        cell.codeLabel.text = cellModel.code
        
        return cell
    }
}
