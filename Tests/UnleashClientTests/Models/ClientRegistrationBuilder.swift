//
//  ClientRegistrationBuilder.swift
//  UnleashTests
//
//  Copyright © 2019 Silvercar. All rights reserved.
//

@testable import UnleashClient
import Foundation

class ClientRegistrationBuilder {
    func build() -> ClientRegistration {
        return ClientRegistration(appName: "Test app", strategies: [])
    }
}
