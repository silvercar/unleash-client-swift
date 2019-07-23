//
//  FeatureBuilder.swift
//  UnleashTests
//
//  Copyright © 2019 Silvercar. All rights reserved.
//

import Foundation

class FeatureBuilder {
    func build() -> Feature {
        let strategy: ActivationStrategy = ActivationStrategyBuilder().withName(name: "default").build()
        let variant: VariantDefinition = VariantDefinitionBuilder().build()
        
        return Feature(name: "feature-one", description: "Feature one", enabled: true, strategies: [strategy],
                       variants: [variant], createdAt: "2019-06-05T19:22:36.027Z")
    }
}
