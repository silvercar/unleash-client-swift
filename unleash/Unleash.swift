//
//  Unleash.swift
//  Unleash
//
//  Copyright © 2019 Silvercar. All rights reserved.
//

import Foundation
import PMKFoundation
import PromiseKit

// MARK: - Strategy
public protocol Strategy {
  var name: String { get }
  func isEnabled(parameters: [String: String]) -> Bool
}

// MARK: - Unleash
public class Unleash {
  
  // MARK: - Properties
  private var registerService: RegisterServiceProtocol
  private var toggleRepository: ToggleRepositoryProtocol
  private var toggles: Toggles? { return toggleRepository.toggles }
  
  public private(set) var appName: String
  public private(set) var url: String
  public private(set) var refreshInterval: Int?
  public private(set) var strategies: [Strategy]
  
  // MARK: - Lifecycle
  public convenience init(
    appName: String, url: String,
    refreshInterval: Int?, strategies: [Strategy] = []
  ) {
    let clientRegistration: ClientRegistration = ClientRegistration(appName: appName, strategies: strategies)
    let registerService: RegisterServiceProtocol = RegisterService()
    let memory: MemoryCache = MemoryCache(cache: Cache(), jsonDecoder: JSONDecoder(), jsonEncoder: JSONEncoder())
    let toggleService: ToggleServiceProtocol
      = ToggleService(appName: appName, instanceId: clientRegistration.instanceId)
    let toggleRepository: ToggleRepository = ToggleRepository(memory: memory, toggleService: toggleService)
    let allStrategies: [Strategy] = [DefaultStrategy()] + strategies
    
    self.init(clientRegistration: clientRegistration, registerService: registerService,
              toggleRepository: toggleRepository, appName: appName, url: url, refreshInterval: refreshInterval,
              strategies: allStrategies)
  }
  
  init(
    clientRegistration: ClientRegistration, registerService: RegisterServiceProtocol,
    toggleRepository: ToggleRepositoryProtocol, appName: String, url: String,
    refreshInterval: Int?, strategies: [Strategy]
  ) {
    self.registerService = registerService
    self.toggleRepository = toggleRepository
    self.appName = appName
    self.url = url
    self.refreshInterval = refreshInterval
    self.strategies = strategies
    
    register(body: clientRegistration)
      .then { _ in
        self.toggleRepository.get(url: URL(string: url)!)
    }
    .catch { error in
      log("error \(error)")
    }
  }
  
  // MARK: - Private Methods
  private func register(body: ClientRegistration) -> Promise<Void> {
    return attempt(maximumRetryCount: 3, delayBeforeRetry: .seconds(60)) {
      self.registerService.register(url: URL(string: self.url)!, body: body)
    }.done { response in
      log("Unleash registered client \(body.instanceId) with response \(response ?? [:])")
    }
  }
  
  private func attempt<T>(
    maximumRetryCount: Int,
    delayBeforeRetry: DispatchTimeInterval,
    _ body: @escaping () -> Promise<T>
  ) -> Promise<T> {
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
  
  // MARK: - Public Methods
  public func isEnabled(name: String) -> Bool {
    guard
      let feature = toggles?.features.first(where: { $0.name == name }),
      !feature.enabled
      else { return false }
    
    for strategy in feature.strategies {
      guard let targetStrategy = strategies.first(where: { $0.name == strategy.name }) else { continue }
      guard let parameters = strategy.parameters else { continue }
      
      if targetStrategy.isEnabled(parameters: parameters) {
        return true
      }
    }
    
    return false
  }
}
