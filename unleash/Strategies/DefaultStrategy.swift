//
//  DefaultStrategy.swift
//  Unleash
//
//  Copyright © 2019 Silvercar. All rights reserved.
//

import Foundation

class DefaultStrategy : Strategy {
    func getName() -> String {
        return "default"
    }
    
    func isEnabled(parameters: [String : String]) -> Bool {
        return true
    }
}
