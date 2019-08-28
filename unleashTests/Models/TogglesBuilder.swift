//
//  TogglesBuilder.swift
//  UnleashTests
//
//  Copyright © 2019 Silvercar. All rights reserved.
//

import Foundation

class TogglesBuilder {
    func build() -> Toggles {
        return Toggles(version: 10, features: [FeatureBuilder().build()])
    }
}
