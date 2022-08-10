//
//  VariantOverride.swift
//  Unleash
//
//  Copyright © 2019 Silvercar. All rights reserved.
//

import Foundation

class VariantOverride: Codable {
    var contextName: String
    var values: [String]
    
    init(contextName: String, values: [String]) {
        self.contextName = contextName
        self.values = values
    }
}
