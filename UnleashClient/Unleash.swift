//
//  Unleash.swift
//  Unleash
//
//  Copyright © 2019 Silvercar. All rights reserved.
//

import Foundation
import PromiseKit

// MARK: - UnleashError
public enum UnleashError: Error {
  case noURLProvided
  case maxRetriesReached
}

// MARK: - Strategy
public protocol Strategy {
  var name: String { get }
  func isEnabled(parameters: [String: String]) -> Bool
}

public protocol UnleashDelegate {
  func unleashDidLoad(_ unleash: Unleash)
  func unleashDidFail(_ unleash: Unleash, withError error: Error)
}

// MARK: - Unleash
public class Unleash {
  
  // MARK: - Properties
  private var registerService: RegisterServiceProtocol
  private var toggleRepository: ToggleRepositoryProtocol
  private var toggles: Toggles? { return toggleRepository.toggles }
  private var scheduler: Scheduler
  
  public private(set) var appName: String
  public private(set) var url: String
  public private(set) var refreshInterval: TimeInterval
  public private(set) var strategies: [Strategy]
  public var delegate: UnleashDelegate?
  
  // MARK: - Lifecycle - Public Init
  public convenience init(
    appName: String,
    url: String,
    refreshInterval: TimeInterval = 3600,
    strategies: [Strategy] = []
  ) {
    let clientRegistration: ClientRegistration = ClientRegistration(appName: appName, strategies: strategies)
    let registerService: RegisterServiceProtocol = RegisterService()
    let memory: MemoryCache = MemoryCache(cache: Cache(), jsonDecoder: JSONDecoder(), jsonEncoder: JSONEncoder())
    let toggleService: ToggleServiceProtocol = ToggleService(appName: appName, instanceId: clientRegistration.instanceId)
    let toggleRepository: ToggleRepository = ToggleRepository(memory: memory, toggleService: toggleService)
    let allStrategies: [Strategy] = [DefaultStrategy()] + strategies
    
    self.init(
      clientRegistration: clientRegistration,
      registerService: registerService,
      toggleRepository: toggleRepository,
      appName: appName,
      url: url,
      refreshInterval: refreshInterval,
      strategies: allStrategies)
  }
  
  // MARK: - Internal Init
  init(
    clientRegistration: ClientRegistration,
    registerService: RegisterServiceProtocol,
    toggleRepository: ToggleRepositoryProtocol,
    appName: String,
    url: String,
    refreshInterval: TimeInterval,
    strategies: [Strategy],
    scheduler: Scheduler? = nil
  ) {
    self.registerService = registerService
    self.toggleRepository = toggleRepository
    self.appName = appName
    self.url = url
    self.refreshInterval = refreshInterval
    self.strategies = strategies
    
    if let scheduler = scheduler {
      self.scheduler = scheduler
    } else {
      self.scheduler = UnleashScheduler.every(interval: Defaults.defaultRetryInterval)
    }
    self.scheduler.delegate = self
    
    start(client: clientRegistration)
  }
  
  // MARK: Start
  private func start(client: ClientRegistration) {
    register(body: client)
    .then { response -> Promise<Void> in
      self.scheduler.do {
        _ = self.fetchToggles().done { self.delegate?.unleashDidLoad(self) }
      }
      self.scheduler.resume()
      return .value(())
    }
    .catch { self.delegate?.unleashDidFail(self, withError: $0) }
  }
  
  // MARK: Register
  private func register(body: ClientRegistration, completion: @escaping (Error?) -> Void) {
    guard
      let url = URL(string: self.url)
      else { return completion(UnleashError.noURLProvided) }
    
    _ = registerService.register(url: url, body: body)
    .tap({ result in
      switch result {
      case .success(let response):
         log("Unleash registered client \(body.instanceId) with response \(response ?? [:])")
        completion(nil)
      case .failure(let error):
        completion(error)
      }
    })
  }
  
  @discardableResult
  private func register(body: ClientRegistration) -> Promise<Void> {
    return Promise { resolver in
      self.register(body: body) { error in resolver.resolve(error) }
    }
  }
  
  // MARK: Fetch Toggles
  private func fetchToggles(completion: @escaping (Error?) -> Void) {
    guard
      let url = URL(string: self.url)
      else { return completion(UnleashError.noURLProvided) }
    
    _ = toggleRepository.get(url: url)
    .tap { result in
      switch result {
      case .success(_):
        completion(nil)
      case .failure(let error):
        completion(error)
      }
    }
  }
  
  @discardableResult
  private func fetchToggles() -> Promise<Void> {
    return Promise { resolver in
      self.fetchToggles { error in resolver.resolve(error) }
    }
  }
  
  // MARK: Is Enabled
  public func isEnabled(name: String) -> Bool {
    guard
      let feature = toggles?.features.first(where: { $0.name == name }),
      feature.enabled
      else { return false }
    
    for strategy in feature.strategies {
      guard
        let targetStrategy = strategies.first(where: { $0.name == strategy.name }),
        let parameters = strategy.parameters
        else { continue }
      
      if targetStrategy.isEnabled(parameters: parameters) {
        return true
      }
    }
    return false
  }
}

// MARK: - Scheduler Delegate
extension Unleash: SchedulerDelegate {
  func schedulerDidFail(_ scheduler: Scheduler, withError error: Error) {
    delegate?.unleashDidFail(self, withError: error)
  }
}
