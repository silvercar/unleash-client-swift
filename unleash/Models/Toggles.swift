//
//  Toggles.swift
//  Unleash
//
//  Copyright © 2019 Silvercar. All rights reserved.
//

import Foundation

class Toggles: Codable {
    var version: Int
    var features: [Feature]
    
    init(version: Int, features: [Feature]) {
        self.version = version
        self.features = features
    }
}
