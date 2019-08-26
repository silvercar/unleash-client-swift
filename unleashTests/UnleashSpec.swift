//
//  UnleashSpec.swift
//  UnleashTests
//
//  Copyright © 2019 Silvercar. All rights reserved.
//

import Foundation
import Nimble
import PromiseKit
import Quick

@testable import Unleash

class UnleashSpec : QuickSpec {
    override func spec() {
        let appName: String = "test"
        let url: String = "https://test.com"
        let interval: Int = 3232
        var clientRegistration: ClientRegistration = ClientRegistration(appName: appName, strategies: [])
        var registerService: RegisterServiceProtocol?
        var toggleService: ToggleServiceProtocol?
        var unleash: Unleash {
            return Unleash(clientRegistration: clientRegistration, registerService: registerService!,
                           toggleService: toggleService!, appName: appName, url: url, refreshInterval: interval,
                           strategies: [])
        }
        
        describe("#init") {
            enum Error: Swift.Error {
                case error
            }
            
            context("when default initializer") {
                let success = Promise<[String : Any]?> { seal in
                    seal.fulfill([:])
                }
                let error = Promise<Features> { _ in
                    throw Error.error
                }
                registerService = RegisterServiceMock(promise: success)
                toggleService = ToggleServiceMock(promise: error)
                
                it("sets default values") {
                    // Act
                    let result = unleash
                    
                    // Assert
                    expect(result.appName).to(equal(appName))
                    expect(result.url).to(equal(url))
                    expect(result.refreshInterval).to(equal(interval))
                    expect(result.strategies).to(beEmpty())
                }
                
                it("sets client registration") {
                    // Act
                    _ = unleash
                    
                    // Assert
                    if let result = (registerService as? RegisterServiceMock)?.body {
                        expect(result.appName).to(equal(appName))
                        expect(result.strategies).to(beEmpty())
                    } else {
                        fail()
                    }
                }
            }
            
            context("when successful registration") {
                it ("will register client") {
                    // Arrange
                    let success = Promise<[String : Any]?> { seal in
                        seal.fulfill([:])
                    }
                    let error = Promise<Features> { _ in
                        throw Error.error
                    }
                    registerService = RegisterServiceMock(promise: success)
                    toggleService = ToggleServiceMock(promise: error)
                    
                    // Act
                    _ = unleash
                    
                    // Arrange
                    expect(success.isResolved).to(beTrue())
                }
            }
            
            context("when unsuccessful registration") {
                it ("will not register client") {
                    // Arrange
                    let registerError = Promise<[String : Any]?> { _ in
                        throw Error.error
                    }
                    let toggleError = Promise<Features> { _ in
                        throw Error.error
                    }
                    registerService = RegisterServiceMock(promise: registerError)
                    toggleService = ToggleServiceMock(promise: toggleError)
                    
                    // Act
                    _ = unleash
                    
                    // Assert
                    expect(registerError.isRejected).to(beTrue())
                }
            }
        }
    }
}
