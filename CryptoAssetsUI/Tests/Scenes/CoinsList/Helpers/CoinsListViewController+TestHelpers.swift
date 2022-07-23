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
    
    @discardableResult
    func coinCell(at index: Int) -> UITableViewCell? {
        let ds = tableView.dataSource
        return ds?.tableView(tableView, cellForRowAt: IndexPath(item: index, section: 0))
    }
    
    @discardableResult
    func didEndDisplayingCell(at index: Int) -> UITableViewCell? {
        let cell = coinCell(at: index)
        let dl = tableView.delegate
        dl?.tableView?(tableView, didEndDisplaying: cell!, forRowAt: IndexPath(row: index, section: 0))
        return cell
    }
    
    func simulateCellNearVisible(at row: Int) {
        let ds = tableView.prefetchDataSource
        let index = IndexPath(row: row, section: 0)
        ds?.tableView(tableView, prefetchRowsAt: [index])
    }

    func simulateCellNotNearVisible(at row: Int) {
        simulateCellNearVisible(at: row)

        let ds = tableView.prefetchDataSource
        let index = IndexPath(row: row, section: 0)
        ds?.tableView?(tableView, cancelPrefetchingForRowsAt: [index])
    }
    
    
}
