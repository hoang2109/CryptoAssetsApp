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
}
