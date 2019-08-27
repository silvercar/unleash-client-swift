//
//  FeatureToggleRepository.swift
//  Unleash
//
//  Copyright © 2019 Silvercar. All rights reserved.
//

import Foundation
import PromiseKit

class FeatureToggleRepository {
    private let key = "unleash-feature-toggles"
    private let memory: MemoryCache
    private let toggleService: ToggleServiceProtocol
    
    init(memory: MemoryCache, toggleService: ToggleServiceProtocol) {
        self.memory = memory
        self.toggleService = toggleService
    }
    
    func get(url: URL) -> Promise<Features> {
        if let features: Features = memory.get(for: key) {
            return Promise { $0.fulfill(features) }
        }
        
        return toggleService.fetchToggles(url: url)
            .map { features in
                self.memory.put(for: self.key, value: features)
                return features
        }
    }
}
