//
//  Unleash.swift
//  Unleash
//
//  Copyright © 2019 Silvercar. All rights reserved.
//

import Foundation
import PMKFoundation
import PromiseKit

public protocol Strategy {
    var name: String { get }
    func isEnabled(parameters: [String: String]) -> Bool
}

public class Unleash {
    private var registerService: RegisterServiceProtocol
    private var toggleService: ToggleServiceProtocol
    public private(set) var appName: String
    public private(set) var url: String
    public private(set) var refreshInterval: Int?
    public private(set) var strategies: [Strategy]
    
    public convenience init(appName: String, url: String, refreshInterval: Int?, strategies: [Strategy] = []) {
        let clientRegistration: ClientRegistration = ClientRegistration(appName: appName, strategies: strategies)
        let registerService: RegisterServiceProtocol = RegisterService()
        let toggleService: ToggleServiceProtocol
            = ToggleService(appName: appName, instanceId: clientRegistration.instanceId)
        let allStrategies: [Strategy] = [DefaultStrategy()] + strategies

        self.init(clientRegistration: clientRegistration, registerService: registerService,
                  toggleService: toggleService, appName: appName, url: url, refreshInterval: refreshInterval,
                  strategies: allStrategies)
    }
    
    init(clientRegistration: ClientRegistration, registerService: RegisterServiceProtocol,
         toggleService: ToggleServiceProtocol, appName: String, url: String, refreshInterval: Int?,
         strategies: [Strategy]) {
        
        self.registerService = registerService
        self.toggleService = toggleService
        self.appName = appName
        self.url = url
        self.refreshInterval = refreshInterval
        self.strategies = strategies
        
        register(body: clientRegistration)
    }
    
    private func register(body: ClientRegistration) {
        attempt(maximumRetryCount: 3, delayBeforeRetry: .seconds(60)) {
            self.registerService.register(url: URL(string: self.url)!, body: body)
        }.done { response in
            log("Unleash registered client \(body.instanceId) with response \(response ?? [:])")
        }.catch { error in
            log("error \(error)")
        }
    }
    
    private func attempt<T>(maximumRetryCount: Int,
                            delayBeforeRetry: DispatchTimeInterval,
                            _ body: @escaping () -> Promise<T>) -> Promise<T> {
        var attempts = 0
        func attempt() -> Promise<T> {
            attempts += 1
            return body().recover { error -> Promise<T> in
                guard attempts < maximumRetryCount else { throw error }
                return after(delayBeforeRetry).then(on: nil, attempt)
            }
        }
        return attempt()
    }
    
    public func isEnabled(name: String) -> Bool {
        toggleService.fetchToggles(url: URL(string: self.url)!)
            .done { response in
                log(dump(response.features.first { $0.name == name }!))
            }.catch { error in
                log("error \(error)")
        }
        
        return false
    }
}
