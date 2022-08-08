//
//  VariantDefinition.swift
//  Unleash
//
//  Copyright © 2019 Silvercar. All rights reserved.
//

import Foundation

class VariantDefinition: Codable {
    var name: String
    var weight: Int
    var payload: Payload
    var overrides: [VariantOverride]?
    
    init(name: String, weight: Int, payload: Payload, overrides: [VariantOverride]?) {
        self.name = name
        self.weight = weight
        self.payload = payload
        self.overrides = overrides
    }
}
