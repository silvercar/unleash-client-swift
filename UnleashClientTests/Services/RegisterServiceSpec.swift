//
//  RegisterServiceSpec.swift
//  UnleashTests
//
//  Copyright © 2019 Silvercar. All rights reserved.
//

import Foundation
import Nimble
import OHHTTPStubs.Swift
import PromiseKit
import Quick

@testable import Unleash

class RegisterServiceSpec : QuickSpec {
    override func spec() {
        var service: RegisterService {
            return RegisterService()
        }
        
        afterEach {
            OHHTTPStubs.removeAllStubs()
        }
        
        describe("#register") {
            let url: String = "https://test.com/"
            let registerUrl: String = "\(url)client/register"
            
            context("when not registered") {
                let json = ["message" : "success"]
                
                beforeEach {
                    stub(condition: { $0.url!.absoluteString == registerUrl }, response: { _ in
                        OHHTTPStubsResponse(jsonObject: json, statusCode: 200, headers: nil)
                    })
                }
                
                it("returns a 200") {
                    // Act / Assert
                    waitUntil { done in
                        service.register(url: URL(string: url)!, body: ClientRegistrationBuilder().build())
                            .done { _ in
                                done()
                            }
                            .catch { _ in
                                fail()
                        }
                    }
                }
                
                it("returns a body") {
                    // Arrange
                    var result: [String : Any]?
                    
                    // Act
                    waitUntil { done in
                        service.register(url: URL(string: url)!, body: ClientRegistrationBuilder().build())
                            .done { response in
                                result = response
                                done()
                            }
                            .catch { _ in
                                fail()
                        }
                    }
                    
                    expect(result as? [String : String]).toEventually(equal(json))
                }
            }
            
            context("when registered") {
                beforeEach {
                    stub(condition: { $0.url!.absoluteString == registerUrl }, response: { _ in
                        OHHTTPStubsResponse(data: "".data(using: String.Encoding.utf8)!, statusCode: 202, headers: nil)
                    })
                }
                
                it("returns a 202") {
                    // Act / Assert
                    waitUntil { done in
                        service.register(url: URL(string: url)!, body: ClientRegistrationBuilder().build())
                            .done { _ in
                                done()
                            }
                            .catch { _ in
                                fail()
                        }
                    }
                }
                
                it("returns no body") {
                    var result: [String : Any]?
                    
                    // Act
                    waitUntil { done in
                        service.register(url: URL(string: url)!, body: ClientRegistrationBuilder().build())
                            .done { response in
                                result = response
                                done()
                            }
                            .catch { _ in
                                fail()
                        }
                    }
                    
                    expect(result as? [String : String]).toEventually(equal([:]))
                }
            }
        }
    }
}
