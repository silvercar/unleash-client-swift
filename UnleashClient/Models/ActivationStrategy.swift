//
//  ActivationStrategy.swift
//  Unleash
//
//  Copyright © 2019 Silvercar. All rights reserved.
//

import Foundation

class ActivationStrategy: Codable {
    var name: String
    var parameters: [String : String]?
    
    init(name: String, parameters: [String: String]?) {
        self.name = name
        self.parameters = parameters
    }
}
