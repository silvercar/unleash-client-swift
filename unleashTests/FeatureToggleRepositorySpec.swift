//
//  FeatureToggleRepositorySpec.swift
//  UnleashTests
//
//  Copyright © 2019 Silvercar. All rights reserved.
//

import Foundation
import Nimble
import PromiseKit
import Quick

@testable import Unleash

class FeatureToggleRepositorySpec: QuickSpec {
    override func spec() {
        let url: URL = URL(string: "https://test.com/client/features")!
        let features: Features = FeaturesBuilder().build()
        var memory: MemoryCache?
        var toggleService: ToggleServiceProtocol?
        var repository: FeatureToggleRepository {
            return FeatureToggleRepository(memory: memory!, toggleService: toggleService!)
        }
        
        describe("#get") {
            context("when has cached feature toggles") {
                it("return cached features") {
                    // Arrange
                    memory = MemoryCache(cache: Cache(), jsonDecoder: JSONDecoder(), jsonEncoder: JSONEncoder())
                    memory?.put(for: "unleash-feature-toggles", value: features)
                    
                    enum Error: Swift.Error {
                        case error
                    }
                    toggleService = ToggleServiceMock(promise: Promise<Features>.init(error: Error.error))
                    
                    // Act/Assert
                    waitUntil { done in
                        repository.get(url: url)
                            .done { features in
                                expect(features).toNot(beNil())
                                done()
                            }.catch { _ in
                                fail()
                        }
                    }
                }
            }
            
            context("when no cached feature toggles") {
                it("return features from API") {
                    // Arrange
                    memory = MemoryCache(cache: Cache(), jsonDecoder: JSONDecoder(), jsonEncoder: JSONEncoder())
                    
                    enum Error: Swift.Error {
                        case error
                    }
                    toggleService = ToggleServiceMock(promise: Promise<Features>.value(features))
                    
                    // Act/Assert
                    waitUntil { done in
                        repository.get(url: url)
                            .done { features in
                                expect(features).toNot(beNil())
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
