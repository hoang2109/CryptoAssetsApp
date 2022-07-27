//
//  ObservationToken.swift
//  CryptoAssetsCore
//
//  Created by Hoang Nguyen on 27/7/22.
//

import Foundation

class ObservationToken: Cancellable {
    private let callBack: (() -> Void)
    
    init(callBack: @escaping () -> Void) {
        self.callBack = callBack
    }
    
    func cancel() {
        callBack()
    }
}
