//
//  ClientRegistrationSpec.swift
//  UnleashTests
//
//  Copyright © 2019 Silvercar. All rights reserved.
//

import Foundation
import Nimble
import Quick

@testable import Unleash

class ClientRegistrationSpec: QuickSpec {
    override func spec() {
        describe("#init") {
            context("when default initializer") {
                let appName = "Unleash"
                let strategy = TestStrategy()
                let strategies = [strategy]
                
                it("sets default values") {
                    // Act
                    let result = ClientRegistration(appName: appName, strategies: strategies)
                    
                    // Assert
                    expect(result.sdkVersion).to(equal("unleash-client-ios:\(AppInfo.shortVersion)"))
                    expect(result.interval).to(equal(10_000))
                }
                
                it("sets app name") {
                    // Act
                    let result = ClientRegistration(appName: appName, strategies: strategies).appName
                    
                    // Assert
                    expect(result).to(equal(appName))
                }
                
                it("sets strategies") {
                    // Act
                    let result = ClientRegistration(appName: appName, strategies: strategies).strategies
                    
                    // Assert
                    expect(result).to(contain(strategy.getName()))
                }
            }
        }
    }
    
    class TestStrategy: Strategy {
        func getName() -> String {
            return "test strategy"
        }
        
        func isEnabled(parameters: [String : String]) -> Bool {
            return false
        }
    }
}
