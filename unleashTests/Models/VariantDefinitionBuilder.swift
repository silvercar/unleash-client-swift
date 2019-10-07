//
//  VariantDefinitionBuilder.swift
//  UnleashTests
//
//  Copyright © 2019 Silvercar. All rights reserved.
//

@testable import Unleash
import Foundation

class VariantDefinitionBuilder {
    func build() -> VariantDefinition {
        // Unleash hasn't built support for more than type=string so not going to create a builder for this
        let payload = Payload(type: "string", value: "string")
        let override = VariantOverrideBuilder().build()
        return VariantDefinition(name: "variant-a", weight: 1, payload: payload, overrides: [override])
    }
}
