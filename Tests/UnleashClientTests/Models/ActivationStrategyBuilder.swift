//
//  ActivationStrategyBuilder.swift
//  UnleashTests
//
//  Copyright © 2019 Silvercar. All rights reserved.
//

@testable import UnleashClient
import Foundation

class ActivationStrategyBuilder {
    private var name: String = ""
    
    func withName(name: String) -> ActivationStrategyBuilder {
        self.name = name
        return self
    }
    
    func build() -> ActivationStrategy {
        return ActivationStrategy(name: name, parameters: [:])
    }
}
