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
        
        XCTAssertEqual(sut.numberOfItems, 2)
        let cell1 = sut.coinCell(at: 0)
        let cell2 = sut.coinCell(at: 1)
        
        XCTAssertEqual(cell1.nameLabel.text, coin1.name)
        XCTAssertEqual(cell1.codeLabel.text, coin1.code)
        
        XCTAssertEqual(cell2.nameLabel.text, coin2.name)
        XCTAssertEqual(cell2.codeLabel.text, coin2.code)
    }
    
    func test_fetchCoinsListCompletion_rendersEmptyCoinsListOnError() {
        let (sut, service) = makeSUT()
        
        sut.loadViewIfNeeded()
        service.didFinishFetchingCoins(with: anyError())
        
        XCTAssertEqual(sut.numberOfItems, 0)
    }
    
    func test_fetchCoinsListCompletion_doesNotAlterRenderCurrentStateOnError() {
        let (sut, service) = makeSUT()
        let coin1 = Coin(name: "Bitcoin", code: "BTC", imageURL: "any")
        let coin2 = Coin(name: "Etherium", code: "ETH", imageURL: "any")
        
        sut.loadViewIfNeeded()
        service.didFinishFetchingCoins(with: [coin1, coin2])
        
        sut.simulateUserInitiatedCoinsListReload()
        service.didFinishFetchingCoins(with: anyError())
        
        XCTAssertEqual(sut.numberOfItems, 2)
        let cell1 = sut.coinCell(at: 0)
        let cell2 = sut.coinCell(at: 1)
        
        XCTAssertEqual(cell1.nameLabel.text, coin1.name)
        XCTAssertEqual(cell1.codeLabel.text, coin1.code)
        
        XCTAssertEqual(cell2.nameLabel.text, coin2.name)
        XCTAssertEqual(cell2.codeLabel.text, coin2.code)
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
