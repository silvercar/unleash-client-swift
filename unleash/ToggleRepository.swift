//
//  ToggleRepository.swift
//  Unleash
//
//  Copyright © 2019 Silvercar. All rights reserved.
//

import Foundation
import PromiseKit

protocol ToggleRepositoryProtocol {
    var toggles: Toggles? { get set }
    func get(url: URL) -> Promise<Toggles>
}

class ToggleRepository: ToggleRepositoryProtocol {
    private let key = "unleash-feature-toggles"
    private let memory: MemoryCache
    private let toggleService: ToggleServiceProtocol
    
    public var toggles: Toggles? {
        get { return memory.get(for: key) }
        set { memory.put(for: key, value: newValue) }
    }
    
    init(memory: MemoryCache, toggleService: ToggleServiceProtocol) {
        self.memory = memory
        self.toggleService = toggleService
    }
    
    func get(url: URL) -> Promise<Toggles> {
        return toggleService.fetchToggles(url: url)
            .map { toggles in
                log(dump(toggles))
                self.toggles = toggles
                return toggles
        }
    }
}
