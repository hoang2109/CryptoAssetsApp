//
//  CoinCell+TestHelpers.swift
//  CryptoAssetsUI
//
//  Created by Hoang Nguyen on 23/7/22.
//

import Foundation
import CryptoAssetsUI

extension CoinCell {
    var name: String? {
        return nameLabel.text
    }
    
    var code: String? {
        return codeLabel.text
    }
}
