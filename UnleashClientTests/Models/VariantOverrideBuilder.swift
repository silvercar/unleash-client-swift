//
//  VariantOverrideBuilder.swift
//  UnleashTests
//
//  Copyright © 2019 Silvercar. All rights reserved.
//
@testable import UnleashClient
import Foundation

class VariantOverrideBuilder {
    func build() -> VariantOverride {
        return VariantOverride(contextName: "userId", values: ["123"])
    }
}
