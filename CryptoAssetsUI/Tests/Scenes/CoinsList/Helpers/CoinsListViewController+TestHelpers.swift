//
//  CoinsListViewController+TestHelpers.swift
//  CryptoAssetsUITests
//
//  Created by Hoang Nguyen on 23/7/22.
//

import Foundation
import CryptoAssetsUI

extension CoinsListViewController {
    func simulateUserInitiatedCoinsListReload() {
        refreshControl?.simulatePullToRefresh()
    }
    
    var isShowingLoadingIndicator: Bool {
        return refreshControl?.isRefreshing == true
    }
}
