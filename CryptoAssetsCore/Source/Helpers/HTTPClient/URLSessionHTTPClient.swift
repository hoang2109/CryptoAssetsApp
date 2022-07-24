//
//  URLSessionHTTPClient.swift
//  CryptoAssetsCore
//
//  Created by Hoang Nguyen on 24/7/22.
//

import Foundation

public class URLSessionHTTPClient: HTTPClient {
    
    private let baseURLProvider: BaseURLProvider
    private let urlSession: URLSession
    private let urlRequestMapper: URLRequestMapper
    
    public init(_ baseURLProvider: BaseURLProvider,
                urlSession: URLSession = .shared) {
        self.baseURLProvider = baseURLProvider
        self.urlSession = urlSession
        urlRequestMapper = URLRequestMapper(baseUrlProvider: baseURLProvider)
    }
    
    private struct UnexpectedValuesRepresentation: Error {}
    private struct Task: Cancellable {
        let sessionTask: URLSessionTask
        
        init(sessionTask: URLSessionDataTask) {
            self.sessionTask = sessionTask
        }
        
        func cancel() {
            sessionTask.cancel()
        }
    }
    
    public func fetch(_ request: HTTPRequest, completion: @escaping (HTTPClient.Result) -> Void) -> Cancellable {
        guard let urlRequest = urlRequestMapper.map(httpRequest: request) else {
            fatalError()
        }
        
        let task = urlSession.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                completion(.failure(error))
            } else if let data = data, let response = response as? HTTPURLResponse {
                completion(.success((data, response)))
            } else {
                completion(.failure(UnexpectedValuesRepresentation()))
            }
        }
        task.resume()
        
        return Task(sessionTask: task)
    }
}
