//
//  DebugLogger.swift
//  Unleash
//
//  Created by Matthew de Anda on 7/17/19.
//  Copyright © 2019 Silvercar. All rights reserved.
//

import Foundation


func log(_ items: Any..., separator: String = "", terminator: String = "\n") {
    #if DEBUG
    debugPrint(items, separator: separator, terminator: terminator)
    #endif
}
