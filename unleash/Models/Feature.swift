//
//  Feature.swift
//  Unleash
//
//  Copyright © 2019 Silvercar. All rights reserved.
//

import Foundation

class Feature: Codable {
    var name: String
    var description: String
    var enabled: Bool
    var strategies: [ActivationStrategy]?
    var variants: [VariantDefinition]?
    var createdAt: String
    
    init(name: String,
         description: String,
         enabled: Bool,
         strategies: [ActivationStrategy]?,
         variants: [VariantDefinition]?,
         createdAt: String) {
        
        self.name = name
        self.description = description
        self.enabled = enabled
        self.strategies = strategies
        self.variants = variants
        self.createdAt = createdAt
    }
}
