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
        
        describe("#toggles") {
            beforeEach {
                memory = MemoryCache(cache: Cache(), jsonDecoder: JSONDecoder(), jsonEncoder: JSONEncoder())
                toggleService = ToggleServiceMock(promise: Promise<Toggles>.init(error: TestError.error))
            }
            
            context("when has cached toggles") {
                it("return cached toggles") {
                    // Arrange
                    memory?.put(for: "unleash-feature-toggles", value: toggles)
                    
                    // Act
                    let result = repository.toggles
                    
                    // Assert
                    expect(result).toNot(beNil())
                }
            }
            
            context("when does not have cached toggles") {
                it("return optional") {
                    // Act
                    let result = repository.toggles
                    
                    // Assert
                    expect(result).to(beNil())
                }
            }
        }
        
        describe("#get") {
            context("when given toggles url") {
                it("return toggles") {
                    // Arrange
                    memory = MemoryCache(cache: Cache(), jsonDecoder: JSONDecoder(), jsonEncoder: JSONEncoder())
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
