//
//  CoinsListViewController+TestHelpers.swift
//  CryptoAssetsUITests
//
//  Created by Hoang Nguyen on 23/7/22.
//

import Foundation
import CryptoAssetsUI
import UIKit

extension CoinsListViewController {
    func simulateUserInitiatedCoinsListReload() {
        refreshControl?.simulatePullToRefresh()
    }
    
    var isShowingLoadingIndicator: Bool {
        return refreshControl?.isRefreshing == true
    }
    
    var numberOfItems: Int {
        tableView.numberOfRows(inSection: 0)
    }
    
    func coinCell(at index: Int) -> CoinCell {
        let ds = tableView.dataSource
        return ds?.tableView(tableView, cellForRowAt: IndexPath(item: index, section: 0)) as! CoinCell
    }
}
