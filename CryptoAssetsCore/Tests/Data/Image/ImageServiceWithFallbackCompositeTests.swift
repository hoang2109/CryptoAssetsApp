//
//  ImageServiceWithFallbackCompositeTests.swift
//  CryptoAssetsAppTests
//
//  Created by Hoang Nguyen on 31/7/22.
//

import XCTest
import CryptoAssetsCore

class ImageServiceWithFallbackCompositeTests: XCTestCase {
    func test_init_doesNotLoadImage() {
        let (_, primary, fallback) = makeSUT()
        
        XCTAssertEqual(primary.loadCalledCount, 0)
        XCTAssertEqual(fallback.loadCalledCount, 0)
    }
    
    func test_load_loadsFromPrimaryServiceFirst() {
        let (sut, primary, fallback) = makeSUT()
        _ = sut.load("/any") { _ in
            
        }
        XCTAssertEqual(primary.loadCalledCount, 1)
        XCTAssertEqual(fallback.loadCalledCount, 0)
    }
    
    func test_load_loadsFromfallBackServiceFirst() {
        let (sut, primary, fallback) = makeSUT()
        _ = sut.load("/any") { _ in
            
        }
        XCTAssertEqual(primary.loadCalledCount, 1)
        XCTAssertEqual(fallback.loadCalledCount, 0)
        
        primary.complete(with: nil)
        
        XCTAssertEqual(primary.loadCalledCount, 1)
        XCTAssertEqual(fallback.loadCalledCount, 1)
    }
    
    func test_cancel_cancelLoad() {
        let (sut, primary, _) = makeSUT()
        let task = sut.load("/any") { _ in
            
        }
        XCTAssertEqual(primary.cancelCalledCount, 0)
        task.cancel()
        
        XCTAssertEqual(primary.cancelCalledCount, 1)
    }
    
    //MARK: - Helpers
    
    private func makeSUT() -> (sut: ImageServiceWithFallbackComposite, primary: ImageServiceSpy, fallBack: ImageServiceSpy) {
        let primary = ImageServiceSpy()
        let fallBack = ImageServiceSpy()
        let sut = ImageServiceWithFallbackComposite(primary: primary, fallback: fallBack)
        return (sut, primary, fallBack)
    }
    
    class TaskSpy: Cancellable {
        
        let callBack: () -> Void
        
        init(callBack: @escaping () -> Void) {
            self.callBack = callBack
        }
        
        func cancel() {
            callBack()
        }
    }
    
    class ImageServiceSpy: ImageService {
        var completions = [(ImageService.Result) -> ()]()
        var loadCalledCount: Int {
            completions.count
        }
        var cancelCalledCount = 0
        
        func load(_ imageURL: String, completion: @escaping (ImageService.Result) -> ()) -> Cancellable {
            completions.append(completion)
            return TaskSpy {
                self.cancelCalledCount += 1
            }
        }
        
        func complete(with data: Data?, at index: Int = 0) {
            completions[index](data)
        }
    }
}
