//
//  CoinTickerTrackerServiceImpl.swift
//  CryptoAssetsCore
//
//  Created by Hoang Nguyen on 24/7/22.
//

import Foundation

public class CoinTickerTrackerServiceImpl: NSObject, CoinTickerTrackerService {
    
    typealias Observer<T> = (T) -> ()
    
    private let url: URL
    private var observers = [UUID: Observer<CoinTicker>]()
    
    var webSocket: URLSessionWebSocketTask?
    
    public init(url: URL) {
        self.url = url
    }
    
    func initWebSocket() {
        webSocket = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue.main).webSocketTask(with: url)
    }
    
    public func connect() {
        initWebSocket()
        webSocket?.resume()
        listen()
    }
    
    public func track(coins: [Coin]) {
        let subRequest = [
            "action": "SubAdd",
            "subs": coins.map{ "2~Binance~\($0.code)~USDT" }
        ] as [String : Any]
        
        if let requestString = subRequest.toJSONString() {
            webSocket?.send(URLSessionWebSocketTask.Message.string(requestString)) { error in
                if let error = error {
                    print("==> onError \(error.localizedDescription)")
                }
            }
        }
    }
    
    public func listen(onChange: @escaping (CoinTicker) -> ()) -> Cancellable {
        let uuid = UUID()
        observers[uuid] = onChange
        return ObservationToken { [weak self] in
            self?.observers.removeValue(forKey: uuid)
        }
    }
    
    func disconnect() {
        webSocket?.cancel(with: .goingAway, reason: nil)
    }
    
    func listen()  {
        webSocket?.receive { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                print("==> onFailure \(error.localizedDescription)")
            case .success(let message):
                switch message {
                case .string(let text):
                    let data = Data(text.utf8)
                    if let coinTicket = try? CoinTickerMapper.map(data) {
                        self.didReceivedCoinTicker(coinTicket)
                    }
                case .data(let data):
                    print("Data message: \(data)")
                @unknown default:
                    fatalError()
                }
            }
            self.listen()
        }
    }
    
    func didReceivedCoinTicker(_ coinTicker: CoinTicker) {
        for observer in observers.values {
            observer(coinTicker)
        }
    }
}

extension CoinTickerTrackerServiceImpl: URLSessionWebSocketDelegate {
    public func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
        print("==> onConnected")
    }
    
    public func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        print("==> onDisconnected")
    }
}
