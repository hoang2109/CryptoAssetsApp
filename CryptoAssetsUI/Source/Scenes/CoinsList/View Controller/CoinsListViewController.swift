//
//  CoinsListViewController.swift
//  CryptoAssetsUI
//
//  Created by Hoang Nguyen on 23/7/22.
//

import Foundation
import UIKit

public class CoinsListViewController: UITableViewController {
    
    var viewModel: CoinsListViewModel? {
        didSet { bind() }
    }
    var tableModel = [CoinCellModel]() {
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
        let cell: CoinCell = tableView.dequeueReusableCell()
        let cellModel = tableModel[indexPath.row]
        cell.configure(cellModel)
        return cell
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
}
