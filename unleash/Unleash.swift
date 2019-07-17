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
    func getName() -> String
    func isEnabled(parameters: [String: String]) -> Bool
}

public class Unleash {
    private var registerService: RegisterServiceProtocol
    public private(set) var appName: String
    public private(set) var url: String
    public private(set) var refreshInterval: Int?
    public private(set) var strategies: [Strategy]
    
    public convenience init(appName: String, url: String, refreshInterval: Int?, strategies: [Strategy] = []) {
        let registerService: RegisterServiceProtocol = RegisterService()
        let allStrategies: [Strategy] = [DefaultStrategy()] + strategies

        self.init(registerService: registerService, appName: appName, url: url, refreshInterval: refreshInterval,
                  strategies: allStrategies)
    }
    
    init(registerService: RegisterServiceProtocol, appName: String, url: String, refreshInterval: Int?,
         strategies: [Strategy]) {
        self.registerService = registerService
        self.appName = appName
        self.url = url
        self.refreshInterval = refreshInterval
        self.strategies = strategies
        
        register()
    }
    
    private func register() {
        let body: ClientRegistration = ClientRegistration(appName: appName, strategies: strategies)
        attempt(maximumRetryCount: 3, delayBeforeRetry: .seconds(60)) {
            self.registerService.register(url: URL(string: self.url)!, body: body)
        }.done {_ in
        }.catch {error in
            debugPrint("error \(error)")
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
        // TODO: Need to implement 
        return false
    }
}
