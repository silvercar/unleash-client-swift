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
        var toggleRepository: ToggleRepositoryProtocol?
        var unleash: Unleash {
            return Unleash(clientRegistration: clientRegistration, registerService: registerService!,
                           toggleRepository: toggleRepository!, appName: appName, url: url, refreshInterval: interval,
                           strategies: [DefaultStrategy()])
        }
        
        beforeEach {
            let error = Promise<[String : Any]?> { _ in
                throw TestError.error
            }
            registerService = RegisterServiceMock(promise: error)
            toggleRepository = ToggleRepositoryMock(toggles: nil)
        }
        
        describe("#init") {
            context("when default initializer") {
                let success = Promise<[String : Any]?> { seal in
                    seal.fulfill([:])
                }
                registerService = RegisterServiceMock(promise: success)
                
                it("sets default values") {
                    // Act
                    let result = unleash
                    
                    // Assert
                    expect(result.appName).to(equal(appName))
                    expect(result.url).to(equal(url))
                    expect(result.refreshInterval).to(equal(interval))
                    expect(result.strategies.count).to(equal(1))
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
                    registerService = RegisterServiceMock(promise: success)
                    
                    // Act
                    _ = unleash
                    
                    // Arrange
                    expect(success.isResolved).to(beTrue())
                }
            }
            
            context("when unsuccessful registration") {
                it ("will not register client") {
                    // Arrange
                    let error = Promise<[String : Any]?> { _ in
                        throw TestError.error
                    }
                    registerService = RegisterServiceMock(promise: error)
                    
                    // Act
                    _ = unleash
                    
                    // Assert
                    expect(error.isRejected).to(beTrue())
                }
            }
        }
        
        describe("#isEnabled") {
            context("when toggles cached") {
                context("when feature disabled") {
                    it("return false") {
                        // Arrange
                        let name = "feature"
                        let feature = FeatureBuilder()
                            .withName(name: name)
                            .disable()
                            .build()
                        let toggles = TogglesBuilder()
                            .withFeature(feature: feature)
                            .build()
                        toggleRepository = ToggleRepositoryMock(toggles: toggles)
                        
                        // Act
                        let result = unleash.isEnabled(name: name)
                        
                        // Assert
                        expect(result).to(beFalse())
                    }
                }
                
                context("when feature enabled") {
                    it("return toggles enabled value") {
                        // Arrange
                        let name = "feature"
                        let feature = FeatureBuilder()
                            .withName(name: name)
                            .build()
                        let toggles = TogglesBuilder()
                            .withFeature(feature: feature)
                            .build()
                        toggleRepository = ToggleRepositoryMock(toggles: toggles)
                        
                        // Act
                        let result = unleash.isEnabled(name: name)
                        
                        // Assert
                        expect(result).to(beTrue())
                    }
                }
            }
            
            context("when toggles not cached") {
                it("return false") {
                    // Act
                    let result = unleash.isEnabled(name: "feature")
                    
                    // Assert
                    expect(result).to(beFalse())
                }
            }
        }
    }
}
