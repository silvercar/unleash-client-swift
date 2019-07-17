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
        var service: RegisterServiceProtocol?
        var unleash: Unleash {
            return Unleash(registerService: service!,
                           appName: appName,
                           url: url,
                           refreshInterval: interval,
                           strategies: [])
        }
        
        describe("#init") {
            context("when default initializer") {
                let success = Promise<[String : Any]?> { seal in
                    seal.fulfill([:])
                }
                service = RegisterServiceMock(promise: success)
                
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
                    if let result = (service as? RegisterServiceMock)?.body {
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
                    service = RegisterServiceMock(promise: success)
                    
                    // Act
                    _ = unleash
                    
                    // Arrange
                    expect(success.isResolved).to(beTrue())
                }
            }
            
            context("when unsuccessful registration") {
                it ("will not register client") {
                    // Arrange
                    enum Error: Swift.Error {
                        case error
                    }
                    
                    let error = Promise<[String : Any]?> { _ in
                        throw Error.error
                    }
                    service = RegisterServiceMock(promise: error)
                    
                    // Act
                    _ = unleash
                    
                    // Assert
                    expect(error.isRejected).to(beTrue())
                }
            }
        }
    }
}
