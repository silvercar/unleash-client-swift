//
//  ToggleServiceSpec.swift
//  UnleashTests
//
//  Copyright © 2019 Silvercar. All rights reserved.
//

import Foundation
import Nimble
import OHHTTPStubs.Swift
import PromiseKit
import Quick

@testable import UnleashClient

class ToggleServiceSpec : QuickSpec {
    override func spec() {
        let appName: String = "test app"
        let instanceId: String = "123"
        var service: ToggleService {
            return ToggleService(appName: appName, instanceId: instanceId)
        }
        var urlRequest: URLRequest?
        
        afterEach {
            OHHTTPStubs.removeAllStubs()
        }
        
        describe("#fetchToggles") {
            let url: String = "https://test.com/"
            let featureUrl: String = "\(url)client/features"
            let toggles: Toggles = TogglesBuilder().build()
            
            beforeEach {
                let encoder = JSONEncoder()
                let json = try? encoder.encode(toggles)
                stub(condition: { $0.url!.absoluteString == featureUrl }, response: { request in
                    urlRequest = request
                    return OHHTTPStubsResponse(data: json!, statusCode: 200, headers: nil)
                })
            }
            
            it("sends app headers") {
                // Act
                waitUntil { done in
                    service.fetchToggles(url: URL(string: url)!)
                        .done { _ in
                            done()
                        }.catch { _ in
                            fail()
                    }
                }
                
                // Assert
                if let result = urlRequest {
                    expect(hasHeaderNamed("UNLEASH-APPNAME", value: appName)(result)).to(beTrue())
                    expect(hasHeaderNamed("UNLEASH-INSTANCEID", value: instanceId)(result)).to(beTrue())
                    expect(hasHeaderNamed("User-Agent", value: appName)(result)).to(beTrue())
                } else {
                    fail()
                }
            }
            
            it("returns toggles") {
                // Act / Assert
                waitUntil { done in
                    service.fetchToggles(url: URL(string: url)!)
                        .done { response in
                            expect(response.version).to(equal(toggles.version))
                            expect(response.features.count).to(equal(toggles.features.count))
                            done()
                        }.catch { _ in
                            fail()
                    }
                }
            }
        }
    }
}
