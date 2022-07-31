//
//  CacheImageServiceTests.swift
//  CryptoAssetsAppTests
//
//  Created by Hoang Nguyen on 31/7/22.
//

import XCTest
import CryptoAssetsCore

class CacheImageServiceTests: XCTestCase {
    
    func test_init_doesNotLoadImageFromCache() {
        let (_, cache) = makeSUT()
        
        XCTAssertEqual(cache.getCalledCount, 0)
    }
    
    func test_load_deliversNilFromCache() {
        let (sut, _) = makeSUT()
        
        let exp = expectation(description: "Waiting for completion")
        _ = sut.load("/any") { result in
            XCTAssertNil(result)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 0.1)
    }
    
    func test_load_deliversImageFromCache() {
        let url = makeBaseURL().appendingPathComponent("/any")
        
        let (sut, cache) = makeSUT()
        let imageData = UIImage.make(withColor: .red).pngData()
        cache.set(url, newValue: imageData)
        
        let exp = expectation(description: "Waiting for completion")
        _ = sut.load("/any") { result in
            XCTAssertEqual(result, imageData)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 0.1)
    }
    
    //MARK: - Helpers
    private func makeSUT() -> (sut: CacheImageService, cache: URLCacheSpy) {
        let cache = URLCacheSpy()
        let sut = CacheImageService(baseURL: makeBaseURL(), cache: cache)
        
        return (sut, cache)
    }
    
    private func makeBaseURL() -> URL {
        URL(string: "http://any.com")!
    }

    class URLCacheSpy: CryptoAssetsCore.URLCache {
        var cache = [URL: Data]()
        var getCalledCount = 0
        
        func get(_ key: URL) -> Data? {
            getCalledCount += 1
            return cache[key]
        }
        
        func set(_ key: URL, newValue: Data?) {
            guard let newValue = newValue else {
                cache.removeValue(forKey: key)
                return
            }
            cache[key] = newValue
        }
    }
}
