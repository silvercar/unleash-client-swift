//
//  ToggleRepositorySpec.swift
//  UnleashTests
//
//  Copyright © 2019 Silvercar. All rights reserved.
//

import Foundation
import Nimble
import PromiseKit
import Quick

@testable import Unleash

class ToggleRepositorySpec: QuickSpec {
    override func spec() {
        let url: URL = URL(string: "https://test.com/client/features")!
        let toggles: Toggles = TogglesBuilder().build()
        var memory: MemoryCache?
        var toggleService: ToggleServiceProtocol?
        var repository: ToggleRepository {
            return ToggleRepository(memory: memory!, toggleService: toggleService!)
        }
        
        describe("#get") {
            context("when has cached toggles") {
                it("return cached toggles") {
                    // Arrange
                    memory = MemoryCache(cache: Cache(), jsonDecoder: JSONDecoder(), jsonEncoder: JSONEncoder())
                    memory?.put(for: "unleash-feature-toggles", value: toggles)
                    
                    enum Error: Swift.Error {
                        case error
                    }
                    toggleService = ToggleServiceMock(promise: Promise<Toggles>.init(error: Error.error))
                    
                    // Act/Assert
                    waitUntil { done in
                        repository.get(url: url)
                            .done { toggles in
                                expect(toggles).toNot(beNil())
                                done()
                            }.catch { _ in
                                fail()
                        }
                    }
                }
            }
            
            context("when no cached toggles") {
                it("return toggles from API") {
                    // Arrange
                    memory = MemoryCache(cache: Cache(), jsonDecoder: JSONDecoder(), jsonEncoder: JSONEncoder())
                    
                    enum Error: Swift.Error {
                        case error
                    }
                    toggleService = ToggleServiceMock(promise: Promise<Toggles>.value(toggles))
                    
                    // Act/Assert
                    waitUntil { done in
                        repository.get(url: url)
                            .done { toggles in
                                expect(toggles).toNot(beNil())
                                done()
                            }.catch { _ in
                                fail()
                        }
                    }
                }
            }
        }
    }
}
