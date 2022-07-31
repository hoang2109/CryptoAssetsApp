//
//  RemoteCoinServiceTests.swift
//  CryptoAssetsAppTests
//
//  Created by Hoang Nguyen on 31/7/22.
//

import XCTest
import CryptoAssetsCore

class RemoteCoinServiceTests: XCTestCase {
    func test_init_doesNotSendRequest() {
        let (_, client) = makeSUT()
        
        XCTAssertEqual(client.requests.count, 0)
    }
    
    func test_fetchCoins_requestsData() {
        let (sut, client) = makeSUT()
        
        sut.fetchCoins { _ in }
        
        XCTAssertEqual(client.requests.count, 1)
        
        sut.fetchCoins { _ in }
        
        XCTAssertEqual(client.requests.count, 2)
    }
    
    func test_fetchCoins_deliversConnectivityErrorOnClientError() {
        let (sut, client) = makeSUT()
        
        expect(sut, toCompleteWith: .failure(.connectivity)) {
            client.completeWith(anyError())
        }
    }
    
    func test_fetchCoins_deliversInvalidDataErrorOnNon200HTTPResponse() {
        let (sut, client) = makeSUT()

        let samples = [199, 201, 300, 400, 500]

        samples.enumerated().forEach { index, code in
            expect(sut, toCompleteWith: .failure(.invalidData), when: {
                let json = makeDataJSON([])
                client.completeWith(statusCode: code, data: json, at: index)
            })
        }
    }

    func test_fetchCoins_deliversInvalidDataErrorOn200HTTPResponseWithInvalidJSON() {
        let (sut, client) = makeSUT()

        expect(sut, toCompleteWith: .failure(.invalidData), when: {
            let invalidJSON = Data("invalid json".utf8)
            client.completeWith(statusCode: 200, data: invalidJSON)
        })
    }
    
    func test_fetchCoins_deliversCoinsListOnSuccessfulResponse() throws {
        guard let pathString = Bundle(for: type(of: self)).path(forResource: "coinslist", ofType: "json") else {
            fatalError("coinslist.json not found")
        }

        guard let jsonString = try? String(contentsOfFile: pathString, encoding: .utf8) else {
            fatalError("Unable to convert coinslist.json to String")
        }
        
        guard let jsonData = jsonString.data(using: .utf8) else {
            fatalError("Unable to convert UnitTestData.json to Data")
        }
        let (sut, client) = makeSUT()
        
        let exp = expectation(description: "Wait for load completion")

        sut.fetchCoins { receivedResult in
            switch receivedResult {
            case let .success(coins):
                XCTAssertEqual(coins.count, 3)
            case .failure(_):
                XCTFail("Expected success result got failure instead")
            }
            exp.fulfill()
        }

        client.completeWith(statusCode: 200, data: jsonData)

        waitForExpectations(timeout: 0.1)
    }
    
    //MARK: - Helpers
    
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (sut: RemoteCoinService, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteCoinService(client)
        
        trackForMemoryLeaks(client, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        
        return (sut, client)
    }
    
    private func anyError() -> NSError {
        NSError(domain: "any error", code: 0)
    }
    
    private func makeDataJSON(_ data: [[String: Any]]) -> Data {
        let json = ["Data": data]
        return try! JSONSerialization.data(withJSONObject: json)
    }
    
    private func expect(_ sut: RemoteCoinService, toCompleteWith expectedResult: Result<[Coin], RemoteCoinService.Error>, when action: () -> Void, file: StaticString = #filePath, line: UInt = #line) {
        let exp = expectation(description: "Wait for load completion")

        sut.fetchCoins { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.success(receivedItems), .success(expectedItems)):
                XCTAssertEqual(receivedItems, expectedItems, file: file, line: line)

            case let (.failure(receivedError as RemoteCoinService.Error), .failure(expectedError)):
                XCTAssertEqual(receivedError, expectedError, file: file, line: line)

            default:
                XCTFail("Expected result \(expectedResult) got \(receivedResult) instead", file: file, line: line)
            }

            exp.fulfill()
        }

        action()

        waitForExpectations(timeout: 0.1)
    }
    
    class HTTPClientSpy: HTTPClient {
        
        var requests = [(request: HTTPRequest, completion: (HTTPClient.Result) -> Void)]()
        
        struct TaskSpy: Cancellable {
            func cancel() {
                
            }
        }
        
        func fetch(_ request: HTTPRequest, completion: @escaping (HTTPClient.Result) -> Void) -> Cancellable {
            requests.append((request, completion))
            return TaskSpy()
        }
        
        func completeWith(_ error: NSError, at index: Int = 0) {
            requests[index].1(.failure(error))
        }
        
        func completeWith(statusCode code: Int, data: Data, at index: Int = 0, file: StaticString = #filePath, line: UInt = #line) {
            let response = HTTPURLResponse(
                url: URL(string: requests[index].request.endPoint)!,
                statusCode: code,
                httpVersion: nil,
                headerFields: nil
            )!
            
            requests[index].completion(.success((data, response)))
        }
    }
}
