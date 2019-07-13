//
//  Unleash.swift
//  Unleash
//
//  Copyright © 2019 Silvercar. All rights reserved.
//

import Foundation
import PMKFoundation
import PromiseKit

public protocol Strategy {
    func getName() -> String
    func isEnabled(parameters: [String: String]) -> Bool
}

public class Unleash {
    private var registerService: RegisterServiceProtocol
    public private(set) var appName: String
    public private(set) var url: String
    public private(set) var refreshInterval: Int?
    public private(set) var strategies: [Strategy]
    
    public convenience init(appName: String, url: String, refreshInterval: Int?, strategies: [Strategy]) {
        let registerService: RegisterServiceProtocol = RegisterService()
        self.init(registerService: registerService, appName: appName, url: url, refreshInterval: refreshInterval,
                  strategies: strategies)
    }
    
    init(registerService: RegisterServiceProtocol, appName: String, url: String, refreshInterval: Int?,
         strategies: [Strategy]) {
        self.registerService = registerService
        self.appName = appName
        self.url = url
        self.refreshInterval = refreshInterval
        self.strategies = strategies
        
        let body: ClientRegistration = ClientRegistration(appName: appName, strategies: strategies)
        registerService.register(url: URL(string: self.url)!, body: body)
            .done {_ in
            }.catch {error in
                print("error \(error)")
        }
    }
    
    public func isEnabled(name: String) -> Bool {
        // TODO: Need to implement 
        return false
    }
}
