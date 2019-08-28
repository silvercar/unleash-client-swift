//
//  ToggleService.swift
//  Unleash
//
//  Copyright © 2019 Silvercar. All rights reserved.
//

import Foundation
import PromiseKit

struct ToggleService: ToggleServiceProtocol {
    private let appName: String
    private let instanceId: String
    
    init(appName: String, instanceId: String) {
        self.appName = appName
        self.instanceId = instanceId
    }
}

protocol ToggleServiceProtocol {
    func fetchToggles(url: URL) -> Promise<Toggles>
}

extension ToggleService {
    func fetchToggles(url: URL) -> Promise<Toggles> {
        let togglesUrl = url.appendingPathComponent("client/features")
        return firstly {
            URLSession.shared.dataTask(.promise, with: try makeUrlRequest(url: togglesUrl)).validate()
            }.map {
                return try JSONDecoder().decode(Toggles.self, from: $0.data)
        }
    }
    
    private func makeUrlRequest(url: URL) throws -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(self.appName, forHTTPHeaderField: "UNLEASH-APPNAME")
        request.addValue(self.instanceId, forHTTPHeaderField: "UNLEASH-INSTANCEID")
        request.addValue(self.appName, forHTTPHeaderField: "User-Agent")
        return request
    }
}
