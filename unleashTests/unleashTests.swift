//
//  UnleashTests.swift
//  UnleashTests
//
//  Copyright © 2019 Silvercar. All rights reserved.
//

import Nimble
import Quick

@testable import Unleash

class UnleashTests: QuickSpec {
    override func spec() {
        describe("When running unit tests") {
            context("should pass") {
                it("should pass") {
                    expect(true).to(beTrue())
                }
            }
        }
    }
}
