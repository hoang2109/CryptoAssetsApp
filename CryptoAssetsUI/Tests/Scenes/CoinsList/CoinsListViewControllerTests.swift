//
//  CoinsListViewControllerTests.swift
//  CryptoAssetsAppTests
//
//  Created by Hoang Nguyen on 23/7/22.
//

import XCTest
import CryptoAssetsUI
import CryptoAssetsCore

class CoinsListViewControllerTests: XCTestCase {
    func test_coisListView_hasTitle() {
        let (sut, _) = makeSUT()
        
        sut.loadViewIfNeeded()
        
        XCTAssertEqual(sut.title, "CryptoAssets")
    }
    
    func test_viewDidLoad_fetchCoinList() {
        let (sut, service) = makeSUT()
        
        sut.loadViewIfNeeded()
        
        XCTAssertEqual(service.fetchCoinsCount, 1)
    }
    
    func test_pullToRefresh_fetchCoinList() {
        let (sut, service) = makeSUT()
        
        sut.loadViewIfNeeded()
        sut.refreshControl?.simulatePullToRefresh()
        
        XCTAssertEqual(service.fetchCoinsCount, 2)
    }
    
    func test_fetchCoinList_showLoadingIndicator() {
        let (sut, _) = makeSUT()
        
        sut.loadViewIfNeeded()
        
        XCTAssertEqual(sut.refreshControl?.isRefreshing, true)
    }
    
    func test_fetchCoinList_hideLoadingIndicatorWhenComplete() {
        let (sut, service) = makeSUT()
        
        sut.loadViewIfNeeded()
        service.didFinishFetchingCoins()
        
        XCTAssertEqual(sut.refreshControl?.isRefreshing, false)
    }
    
    //MARK: - Helper
    
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (sut: CoinsListViewController, service: CoinServiceSpy) {
        let service = CoinServiceSpy()
        let sut = CoinsListUIComposer.coinsListComposedWith(coinService: service)
        trackForMemoryLeaks(service, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, service)
    }
    
    private class CoinServiceSpy: CoinService {
        var fetchCoinsCount: Int {
            return completions.count
        }
        
        var completions: [(CoinService.Result) -> ()] = []
        
        func fetchCoins(_ completion: @escaping (CoinService.Result) -> ()) {
            completions.append(completion)
        }
        
        func didFinishFetchingCoins() {
            completions[0](.success([]))
        }
    }
}
