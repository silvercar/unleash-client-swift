//
//  ToggleServiceMock.swift
//  UnleashTests
//
//  Copyright © 2019 Silvercar. All rights reserved.
//

import Foundation
import PromiseKit

class ToggleServiceMock : ToggleServiceProtocol {
    
    private let promise: Promise<Features>
    
    init(promise: Promise<Features>) {
        self.promise = promise
    }
    
    func fetchToggles(url: URL) -> Promise<Features> {
        return promise
    }
}
