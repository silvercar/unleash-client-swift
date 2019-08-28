//
//  ToggleRepository.swift
//  Unleash
//
//  Copyright © 2019 Silvercar. All rights reserved.
//

import Foundation
import PromiseKit

class ToggleRepository {
    private let key = "unleash-feature-toggles"
    private let memory: MemoryCache
    private let toggleService: ToggleServiceProtocol
    
    init(memory: MemoryCache, toggleService: ToggleServiceProtocol) {
        self.memory = memory
        self.toggleService = toggleService
    }
    
    func get(url: URL) -> Promise<Toggles> {
        if let toggles: Toggles = memory.get(for: key) {
            return Promise { $0.fulfill(toggles) }
        }
        
        return toggleService.fetchToggles(url: url)
            .map { toggles in
                self.memory.put(for: self.key, value: toggles)
                return toggles
        }
    }
}
