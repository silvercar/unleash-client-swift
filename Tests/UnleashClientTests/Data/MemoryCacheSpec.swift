//
//  MemoryCacheSpec.swift
//  UnleashTests
//
//  Copyright © 2019 Silvercar. All rights reserved.
//

import Foundation
import Nimble
import Quick

@testable import UnleashClient

class MemoryCacheSpec: QuickSpec {
    override func spec() {
        let jsonEncoder: JSONEncoder = JSONEncoder()
        var cache: Cache = Cache()
        var memoryCache: MemoryCache {
            return MemoryCache(cache: cache, jsonDecoder: JSONDecoder(), jsonEncoder: jsonEncoder)
        }
        
        describe("#get") {
            let key = "key"
            let value: Test = Test(test1: "test", test2: 1)
            
            beforeEach {
                cache = Cache()
            }
            
            context("when given a valid key") {
                beforeEach {
                    if let data = try? jsonEncoder.encode(value) {
                        cache[key] = data
                    }
                }
                
                it("return value") {
                    // Act
                    let result: Test? = memoryCache.get(for: key)
                    
                    // Assert
                    expect(result).to(equal(value))
                }
            }
            context("when given an invalid key") {
                it("return nil") {
                    // Act
                    let result: Test? = memoryCache.get(for: key)
                    
                    // Assert
                    expect(result).to(beNil())
                }
            }
            context("when data can't be parsed") {
                it("return nil") {
                    // Arrange
                    cache[key] = Data([0x001])
                    
                    // Act
                    let result: Test? = memoryCache.get(for: key)
                    
                    // Assert
                    expect(result).to(beNil())
                }
            }
        }
        
        describe("#put") {
            let key = "test2"
            let value: Test = Test(test1: "test2", test2: 2)
            
            beforeEach {
                cache = Cache()
            }
            
            context("when adding valid value") {
                it("save to cache") {
                    // Act
                    memoryCache.put(for: key, value: value)
                    
                    // Assert
                    expect(cache[key]).toNot(beNil())
                }
            }
        }
    }
}

class Test: Codable, Equatable {
    var test1: String
    var test2: Int
    
    init(test1: String, test2: Int) {
        self.test1 = test1
        self.test2 = test2
    }
    
    static func == (lhs: Test, rhs: Test) -> Bool {
        return (lhs.test1 == rhs.test1) && (lhs.test2 == rhs.test2)
    }
}
