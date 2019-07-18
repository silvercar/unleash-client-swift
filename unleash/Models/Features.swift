//
//  Features.swift
//  Unleash
//
//  Copyright © 2019 Silvercar. All rights reserved.
//

import Foundation

class Features: Codable {
    var version: Int
    var features: [Feature]
    
    init(version: Int, features: [Feature]) {
        self.version = version
        self.features = features
    }
}
