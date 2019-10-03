//
//  ToggleRespositoryMock.swift
//  UnleashTests
//
//  Copyright © 2019 Silvercar. All rights reserved.
//

@testable import Unleash
import Foundation
import PromiseKit

class ToggleRepositoryMock: ToggleRepositoryProtocol {
    var toggles: Toggles?
    
    init(toggles: Toggles?) {
        self.toggles = toggles
    }
    
    func get(url: URL) -> Promise<Toggles> {
        if let toggles = self.toggles {
            return Promise.value(toggles)
        }
        return Promise.init(error: TestError.error)
    }
}
