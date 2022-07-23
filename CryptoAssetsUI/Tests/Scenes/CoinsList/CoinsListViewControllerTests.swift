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
        sut.simulateUserInitiatedCoinsListReload()
        
        XCTAssertEqual(service.fetchCoinsCount, 2)
    }
    
    func test_fetchCoinList_showLoadingIndicator() {
        let (sut, _) = makeSUT()
        
        sut.loadViewIfNeeded()
        
        XCTAssertEqual(sut.isShowingLoadingIndicator, true)
    }
    
    func test_fetchCoinList_hideLoadingIndicatorWhenComplete() {
        let (sut, service) = makeSUT()
        
        sut.loadViewIfNeeded()
        service.didFinishFetchingCoins()
        
        XCTAssertEqual(sut.isShowingLoadingIndicator, false)
    }
    
    func test_fetchCoinsListCompletion_rendersSuccessfullyCoinsList() {
        let (sut, service) = makeSUT()
        let coin1 = Coin(name: "Bitcoin", code: "BTC", imageURL: "any")
        let coin2 = Coin(name: "Etherium", code: "ETH", imageURL: "any")
        
        sut.loadViewIfNeeded()
        
        service.didFinishFetchingCoins(with: [coin1, coin2])
        
        assertThat(sut, rendersUIForCoins: [coin1, coin2])
    }
    
    func test_fetchCoinsListCompletion_rendersEmptyCoinsListOnError() {
        let (sut, service) = makeSUT()
        
        sut.loadViewIfNeeded()
        service.didFinishFetchingCoins(with: anyError())
        
        assertThat(sut, rendersUIForCoins: [])
    }
    
    func test_fetchCoinsListCompletion_doesNotAlterRenderCurrentStateOnError() {
        let (sut, service) = makeSUT()
        let coin1 = Coin(name: "Bitcoin", code: "BTC", imageURL: "any")
        let coin2 = Coin(name: "Etherium", code: "ETH", imageURL: "any")
        
        sut.loadViewIfNeeded()
        service.didFinishFetchingCoins(with: [coin1, coin2])
        
        sut.simulateUserInitiatedCoinsListReload()
        service.didFinishFetchingCoins(with: anyError())
        
        assertThat(sut, rendersUIForCoins: [coin1, coin2])
    }
    
    //MARK: - Helper
    
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (sut: CoinsListViewController, service: CoinServiceSpy) {
        let service = CoinServiceSpy()
        let sut = CoinsListUIComposer.coinsListComposedWith(coinService: service)
        trackForMemoryLeaks(service, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, service)
    }
    
    private func anyError() -> Error {
        return NSError(domain: "any error", code: 0)
    }
    
    private func assertThat(_ sut: CoinsListViewController, rendersUIForCoins coins: [Coin], file: StaticString = #filePath, line: UInt = #line) {
        XCTAssertEqual(sut.numberOfItems, coins.count, "Expected \(coins.count) items, got \(sut.numberOfItems) instead", file: file, line: line)
        
        coins.enumerated().forEach { index, item in
            assertThat(sut, hasViewConfigureFor: item, at: index)
        }
    }
    
    private func assertThat(_ sut: CoinsListViewController, hasViewConfigureFor item: Coin, at index: Int, file: StaticString = #filePath, line: UInt = #line) {
        let view = sut.coinCell(at: index)
        guard let cell = view as? CoinCell  else {
            XCTFail("Expected \(CoinCell.self) instance, get \(String(describing: view)) instead", file: file, line: line)
            return
        }
        XCTAssertEqual(cell.name, item.name, "Expected name text to be \(String(describing: item.name)) for coin at index (\(index))", file: file, line: line)
        XCTAssertEqual(cell.code, item.code, "Expected code text to be \(String(describing: item.code)) for coin at index (\(index))", file: file, line: line)
    }
    
    private class CoinServiceSpy: CoinService {
        var fetchCoinsCount: Int {
            return completions.count
        }
        
        var completions: [(CoinService.Result) -> ()] = []
        
        func fetchCoins(_ completion: @escaping (CoinService.Result) -> ()) {
            completions.append(completion)
        }
        
        func didFinishFetchingCoins(at index: Int = 0) {
            completions[index](.success([]))
        }
        
        func didFinishFetchingCoins(at index: Int = 0, with coins: [Coin]) {
            completions[index](.success(coins))
        }
        
        func didFinishFetchingCoins(at index: Int = 0, with error: Error) {
            completions[index](.failure(error))
        }
    }
}
