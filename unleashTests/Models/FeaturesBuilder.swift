//
//  FeaturesBuilder.swift
//  UnleashTests
//
//  Copyright © 2019 Silvercar. All rights reserved.
//

import Foundation

class FeaturesBuilder {
    func build() -> Features {
        return Features(version: 10, features: [FeatureBuilder().build()])
    }
}
