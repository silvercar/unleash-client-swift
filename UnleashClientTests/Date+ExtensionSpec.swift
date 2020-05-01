//
//  DateExtensionSpec.swift
//  UnleashTests
//
//  Copyright © 2019 Silvercar. All rights reserved.
//

import Foundation
import Nimble
import Quick

@testable import Unleash

class DateExtensionSpec: QuickSpec {
    override func spec() {
        describe("#iso8601DateString") {
            context("when given a date") {
                it("formats to ISO 8601 string") {
                    let isoformatter = ISO8601DateFormatter.init()
                    let date = isoformatter.date(from: "2016-11-01T21:14:10Z")
                 
                    expect(date?.iso8601DateString).to(equal("2016-11-01T21:14:10.000Z"))
                }
            }
        }
    }
}
