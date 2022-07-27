//
//  CoinCell.swift
//  CryptoAssetsUI
//
//  Created by Hoang Nguyen on 23/7/22.
//

import Foundation
import UIKit

public class CoinCell: UITableViewCell {
    @IBOutlet public private(set) weak var iconImageView: UIImageView!
    @IBOutlet public private(set) weak var nameLabel: UILabel!
    @IBOutlet public private(set) weak var codeLabel: UILabel!
    @IBOutlet public private(set) weak var priceLabel: UILabel!
    @IBOutlet public private(set) weak var changeContainerView: UIView!
    @IBOutlet public private(set) weak var changeLabel: UILabel!
    
    func configure(_ cellModel: CoinCellModel) {
        nameLabel.text = cellModel.name
        codeLabel.text = cellModel.code
        priceLabel.text = cellModel.price
        changeLabel.text = cellModel.changePercentage
        
        let color = colorForPriceChange(changed: cellModel.changeType)
        priceLabel.textColor = color
        changeContainerView.backgroundColor = color
    }
    
    func setImage(_ data: Data) {
        iconImageView.image = UIImage(data: data)
    }
    
    private func colorForPriceChange(changed: CoinCellModel.ChangedType) -> UIColor {
        switch changed {
        case .increase:
            return Style.colorGreen
        case .decrease:
            return Style.colorRed
        case .noChanged:
            return UIColor.systemGray2
        }
    }
}
