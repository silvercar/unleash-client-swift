//
//  FeatureBuilder.swift
//  UnleashTests
//
//  Copyright © 2019 Silvercar. All rights reserved.
//
@testable import UnleashClient
import Foundation

class FeatureBuilder {
    private var name = "feature-one"
    private var isEnabled = true
    
    func withName(name: String) -> FeatureBuilder {
        self.name = name
        return self
    }
    
    func disable() -> FeatureBuilder {
        self.isEnabled = false
        return self
    }
    
    func build() -> Feature {
        let strategy: ActivationStrategy = ActivationStrategyBuilder().withName(name: "default").build()
        let variant: VariantDefinition = VariantDefinitionBuilder().build()
        
        return Feature(name: name, description: "Feature one", enabled: isEnabled, strategies: [strategy],
                       variants: [variant], createdAt: "2019-06-05T19:22:36.027Z")
    }
}
