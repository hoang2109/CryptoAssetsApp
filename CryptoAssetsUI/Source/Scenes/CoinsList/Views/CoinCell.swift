//
//  CoinCell.swift
//  CryptoAssetsUI
//
//  Created by Hoang Nguyen on 23/7/22.
//

import Foundation
import UIKit

class CoinCell: UITableViewCell {
    @IBOutlet private(set) weak var iconImageView: UIImageView!
    @IBOutlet private(set) weak var nameLabel: UILabel!
    @IBOutlet private(set) weak var codeLabel: UILabel!
    @IBOutlet private(set) weak var priceLabel: UILabel!
    @IBOutlet private(set) weak var changeContainerView: UIView!
    @IBOutlet private(set) weak var changeLabel: UILabel!
    
    func configure(_ cellModel: CoinCellModel) {
        nameLabel.text = cellModel.name
        codeLabel.text = cellModel.code
        priceLabel.text = ""
        changeLabel.text = ""
    }
}
