//
//  ClientRegistration.swift
//  Unleash
//
//  Copyright © 2019 Silvercar. All rights reserved.
//

import Foundation

final class ClientRegistration: Codable {
    var appName: String
    var instanceId: String
    var sdkVersion: String
    var strategies: [String]
    var started: String
    var interval: Int
    
    init(appName: String, strategies: [Strategy]) {
        self.appName = appName
        // TODO: This shouldn't be re-generated per instance of the library, need to store this value and re-use 
        self.instanceId = UUID().uuidString
        self.sdkVersion = "unleash-client-ios:\(AppInfo.shortVersion)"
        self.strategies = strategies.map { $0.name }
        self.started = Date().iso8601DateString
        self.interval = 10_000
    }
}
