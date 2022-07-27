//
//  Formatter+Helper.swift
//  CryptoAssetsUI
//
//  Created by Hoang Nguyen on 26/7/22.
//

import Foundation

extension Formatter {
    static let currencyFormat: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 8
        formatter.minimumFractionDigits = 0
        formatter.numberStyle = .currency
        formatter.groupingSeparator = "."
        formatter.locale = Locale.init(identifier: "en_US")
        return formatter
    }()
    
    static let diffFormat: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = "."
        formatter.positivePrefix = formatter.plusSign
        formatter.negativePrefix = formatter.minusSign
        return formatter
    }()
    
    static let percentageFormat: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        formatter.numberStyle = .percent
        formatter.groupingSeparator = "."
        formatter.positivePrefix = formatter.plusSign
        formatter.negativePrefix = formatter.minusSign
        return formatter
    }()
}
