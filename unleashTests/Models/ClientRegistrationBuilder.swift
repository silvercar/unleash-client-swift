//
//  ClientRegistrationBuilder.swift
//  UnleashTests
//
//  Copyright © 2019 Silvercar. All rights reserved.
//

import Foundation

class ClientRegistrationBuilder {
    func build() -> ClientRegistration {
        return ClientRegistration(appName: "Test app", strategies: [])
    }
}
