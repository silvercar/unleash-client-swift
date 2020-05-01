//
//  Payload.swift
//  Unleash
//
//  Copyright © 2019 Silvercar. All rights reserved.
//

import Foundation

class Payload: Codable {
    var type: String
    var value: String
    
    init(type: String, value: String) {
        self.type = type
        self.value = value
    }
}
