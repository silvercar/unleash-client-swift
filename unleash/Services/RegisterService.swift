//
//  RegisterService.swift
//  Unleash
//
//  Copyright © 2019 Silvercar. All rights reserved.
//

import Foundation
import PromiseKit

struct RegisterService: RegisterServiceProtocol {}

protocol RegisterServiceProtocol {
    func register(url: URL, body: ClientRegistration) -> Promise<[String: Any]?>
}

extension RegisterService {
    func register(url: URL, body: ClientRegistration) -> Promise<[String: Any]?> {
        let registerUrl = url.appendingPathComponent("client/register")
        return firstly {
            URLSession.shared.dataTask(.promise, with: try makeUrlRequest(url: registerUrl, body: body)).validate()
        }.map {
            try JSONSerialization.jsonObject(with: $0.data) as? [String: Any]
        }
    }
    
    private func makeUrlRequest(url: URL, body: ClientRegistration) throws -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = try JSONEncoder().encode(body)
        return request
    }
}
