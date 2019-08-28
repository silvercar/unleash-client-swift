//
//  ToggleServiceMock.swift
//  UnleashTests
//
//  Copyright © 2019 Silvercar. All rights reserved.
//

import Foundation
import PromiseKit

class ToggleServiceMock : ToggleServiceProtocol {
    
    private let promise: Promise<Toggles>
    
    init(promise: Promise<Toggles>) {
        self.promise = promise
    }
    
    func fetchToggles(url: URL) -> Promise<Toggles> {
        return promise
    }
}
