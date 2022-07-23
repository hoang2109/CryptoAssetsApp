//
//  CoinsListViewController.swift
//  CryptoAssetsUI
//
//  Created by Hoang Nguyen on 23/7/22.
//

import Foundation
import UIKit

public class CoinsListViewController: UITableViewController, UITableViewDataSourcePrefetching {
    
    var viewModel: CoinsListViewModel? {
        didSet { bind() }
    }
    var tableModel = [CoinCellController]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    public override func viewDidLoad() {
        fetchCoins()
    }
    
    @IBAction func fetchCoins() {
        viewModel?.fetchCoinsList()
    }
    
    // MARK: - UITableViewDataSource
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableModel.count
    }
    
    // MARK: - UITableViewDataDelegate
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        cellController(for: indexPath.row).cellForTableView(tableView)
    }
    
    public override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cellController(for: indexPath.row).cancelLoad()
    }
    
    // MARK: - UITableViewDataSourcePrefetching
    
    public func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { indexPath in
            cellController(for: indexPath.row).preload()
        }
    }
    
    public func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { indexPath in
            cellController(for: indexPath.row).cancelLoad()
        }
    }
    
    private func bind() {
        viewModel?.onCoinChange = { [weak self] items in
            guard let self = self else { return }
            self.tableModel = items
        }
        
        viewModel?.onLoadingChange = { [weak self] isLoading in
            guard let self = self else { return }
            if isLoading {
                self.refreshControl?.beginRefreshing()
            } else {
                self.refreshControl?.endRefreshing()
            }
        }
    }
    
    private func cellController(for row: Int) -> CoinCellController {
        tableModel[row]
    }
}
