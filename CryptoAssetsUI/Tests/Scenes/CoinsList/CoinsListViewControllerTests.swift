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
        let coin1 = Coin(name: "Bitcoin", code: "BTC", imageURL: "any", price: 21100, open24Hour: 21000)
        let coin2 = Coin(name: "Etherium", code: "ETH", imageURL: "any", price: 1600, open24Hour: 1500)
        
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
        let coin1 = Coin(name: "Bitcoin", code: "BTC", imageURL: "any", price: 21100, open24Hour: 21000)
        let coin2 = Coin(name: "Etherium", code: "ETH", imageURL: "any", price: 1600, open24Hour: 1500)
        
        sut.loadViewIfNeeded()
        service.didFinishFetchingCoins(with: [coin1, coin2])
        
        sut.simulateUserInitiatedCoinsListReload()
        service.didFinishFetchingCoins(with: anyError())
        
        assertThat(sut, rendersUIForCoins: [coin1, coin2])
    }
    
    func test_cellAppear_callLoadImage() {
        let (sut, service) = makeSUT()
        
        let coin1 = Coin(name: "Bitcoin", code: "BTC", imageURL: "/btc", price: 21100, open24Hour: 21000)
        let coin2 = Coin(name: "Etherium", code: "ETH", imageURL: "/eth", price: 1600, open24Hour: 1500)
        
        sut.loadViewIfNeeded()
        service.didFinishFetchingCoins(with: [coin1, coin2])
        
        sut.coinCell(at: 0)
        XCTAssertEqual(service.loadImageURLs, [coin1.imageURL])
        
        sut.coinCell(at: 1)
        XCTAssertEqual(service.loadImageURLs, [coin1.imageURL, coin2.imageURL])
    }
    
    func test_loadImage_rendersImageSuccessfullyOnCompletion() {
        let (sut, service) = makeSUT()
        
        let coin1 = Coin(name: "Bitcoin", code: "BTC", imageURL: "any", price: 21100, open24Hour: 21000)
        let coin2 = Coin(name: "Etherium", code: "ETH", imageURL: "any", price: 1600, open24Hour: 1500)
        let redImageData = UIImage.make(withColor: .red).pngData()!
        let blueImageData = UIImage.make(withColor: .blue).pngData()!
        
        sut.loadViewIfNeeded()
        service.didFinishFetchingCoins(with: [coin1, coin2])
        
        let cell1 = sut.coinCell(at: 0) as! CoinCell
        let cell2 = sut.coinCell(at: 1) as! CoinCell
        
        service.didFinishLoadingImage(at: 0, data: redImageData)
        XCTAssertEqual(cell1.iconImageView.image?.pngData(), redImageData)
        
        service.didFinishLoadingImage(at: 1, data: blueImageData)
        XCTAssertEqual(cell2.iconImageView.image?.pngData(), blueImageData)
    }
    
    func test_endDisplayingCell_cancelLoadImage() {
        let (sut, service) = makeSUT()
        
        let coin1 = Coin(name: "Bitcoin", code: "BTC", imageURL: "any", price: 21100, open24Hour: 21000)
        let coin2 = Coin(name: "Etherium", code: "ETH", imageURL: "any", price: 1600, open24Hour: 1500)
        
        sut.loadViewIfNeeded()
        service.didFinishFetchingCoins(with: [coin1, coin2])
        
        sut.coinCell(at: 0)
        sut.coinCell(at: 1)
        
        sut.didEndDisplayingCell(at: 0)
        XCTAssertEqual(service.cancelLoadImageURLs, [coin1.imageURL])
        
        sut.didEndDisplayingCell(at: 1)
        XCTAssertEqual(service.cancelLoadImageURLs, [coin1.imageURL, coin2.imageURL])
    }
    
    func test_endDisplayingCell_notRendersImageOnCompletion() {
        let (sut, service) = makeSUT()
        
        let coin1 = Coin(name: "Bitcoin", code: "BTC", imageURL: "any", price: 21100, open24Hour: 21000)
        let coin2 = Coin(name: "Etherium", code: "ETH", imageURL: "any", price: 1600, open24Hour: 1500)
        
        sut.loadViewIfNeeded()
        service.didFinishFetchingCoins(with: [coin1, coin2])
        
        let cell = sut.didEndDisplayingCell(at: 0) as! CoinCell
        
        service.didFinishLoadingImage(data: UIImage.make(withColor: .red).pngData()!)
        
        XCTAssertNil(cell.renderImage)
    }
    
    func test_cellNearVisible_preloadImage() {
        let (sut, service) = makeSUT()
        
        let coin1 = Coin(name: "Bitcoin", code: "BTC", imageURL: "/btc", price: 21100, open24Hour: 21000)
        let coin2 = Coin(name: "Etherium", code: "ETH", imageURL: "/eth", price: 1600, open24Hour: 1500)
        
        sut.loadViewIfNeeded()
        service.didFinishFetchingCoins(with: [coin1, coin2])
        
        sut.simulateCellNearVisible(at: 0)
        
        XCTAssertEqual(service.loadImageURLs, [coin1.imageURL])
        
        sut.simulateCellNearVisible(at: 1)
        XCTAssertEqual(service.loadImageURLs, [coin1.imageURL, coin2.imageURL])
    }
    
    func test_cellNotNearVisible_cancelPreloadImage() {
        let (sut, service) = makeSUT()
        
        let coin1 = Coin(name: "Bitcoin", code: "BTC", imageURL: "/btc", price: 21100, open24Hour: 21000)
        let coin2 = Coin(name: "Etherium", code: "ETH", imageURL: "/eth", price: 1600, open24Hour: 1500)
        
        sut.loadViewIfNeeded()
        service.didFinishFetchingCoins(with: [coin1, coin2])
        
        sut.simulateCellNotNearVisible(at: 0)
        
        XCTAssertEqual(service.cancelLoadImageURLs, [coin1.imageURL])
        
        sut.simulateCellNotNearVisible(at: 1)
        XCTAssertEqual(service.cancelLoadImageURLs, [coin1.imageURL, coin2.imageURL])
    }
    
    func test_fetchCoinsCompletion_dispatchesFromBackGroundToMainThrea() {
        let coin1 = Coin(name: "Bitcoin", code: "BTC", imageURL: "/btc", price: 21100, open24Hour: 21000)
        let coin2 = Coin(name: "Etherium", code: "ETH", imageURL: "/eth", price: 1600, open24Hour: 1500)
        let (sut, service) = makeSUT()
        
        sut.loadViewIfNeeded()
        
        let exp = expectation(description: "Waiting for completion")
        
        DispatchQueue.global().async {
            service.didFinishFetchingCoins(with: [coin1, coin2])
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
    }
    
    func test_loadImageCompletion_dispatchesFromBackGroundToMainThrea() {
        let coin1 = Coin(name: "Bitcoin", code: "BTC", imageURL: "/btc", price: 21100, open24Hour: 21000)
        let coin2 = Coin(name: "Etherium", code: "ETH", imageURL: "/eth", price: 1600, open24Hour: 1500)
        let (sut, service) = makeSUT()
        
        sut.loadViewIfNeeded()
        service.didFinishFetchingCoins(with: [coin1, coin2])
        
        sut.coinCell(at: 0)
        
        let exp = expectation(description: "Waiting for completion")
        
        DispatchQueue.global().async {
            service.didFinishLoadingImage(data: UIImage.make(withColor: .red).pngData()!)
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
    }
    
    //MARK: - Helper
    
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (sut: CoinsListViewController, service: ServiceSpy) {
        let service = ServiceSpy()
        let sut = CoinsListUIComposer.coinsListComposedWith(coinService: service, imageService: service, coinTickerTrackerService: service)
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
    
    private class ServiceSpy: CoinService, ImageService, CoinTickerTrackerService {
        
        // MARK: - CoinService
        var fetchCoinsCount: Int {
            return fetchCoinsCompletions.count
        }
        
        private(set) var fetchCoinsCompletions: [(CoinService.Result) -> ()] = []
        
        func fetchCoins(_ completion: @escaping (CoinService.Result) -> ()) {
            fetchCoinsCompletions.append(completion)
        }
        
        func didFinishFetchingCoins(at index: Int = 0) {
            fetchCoinsCompletions[index](.success([]))
        }
        
        func didFinishFetchingCoins(at index: Int = 0, with coins: [Coin]) {
            fetchCoinsCompletions[index](.success(coins))
        }
        
        func didFinishFetchingCoins(at index: Int = 0, with error: Error) {
            fetchCoinsCompletions[index](.failure(error))
        }
        
        // MARK: - ImageService
        
        private class TaskSpy: Cancellable {
            let onCancel: () -> ()
            
            init(onCancel: @escaping () -> ()) {
                self.onCancel = onCancel
            }
            
            func cancel() {
                onCancel()
            }
        }
        
        var loadImageURLs: [String] = []
        var cancelLoadImageURLs: [String] = []
        
        private(set) var loadImageCompletions: [(ImageService.Result) -> ()] = []
        
        func load(_ imageURL: String, completion: @escaping (ImageService.Result) -> ()) -> Cancellable {
            loadImageURLs.append(imageURL)
            loadImageCompletions.append(completion)
            return TaskSpy {
                self.cancelLoadImageURLs.append(imageURL)
            }
        }
        
        func didFinishLoadingImage(at index: Int = 0, data: Data) {
            loadImageCompletions[index](data)
        }
        
        // MARK: - CoinTickerTrackerService
        func connect() {
            
        }
        
        func track(coins: [Coin]) {
            
        }
        
        func listen(onChange: @escaping (CoinTicker) -> ()) -> Cancellable {
            return TaskSpy { }
        }
    }
}
