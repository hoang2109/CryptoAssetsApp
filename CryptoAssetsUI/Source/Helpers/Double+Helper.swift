//
//  Double+Helper.swift
//  CryptoAssetsUI
//
//  Created by Hoang Nguyen on 26/7/22.
//

import Foundation

extension Double {
    var currencyFormat: String { Formatter.currencyFormat.string(for: self) ?? "" }
    var percentageFormat: String { Formatter.percentageFormat.string(for: self) ?? "" }
}
