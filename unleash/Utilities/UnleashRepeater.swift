//
//  UnleashRepeater.swift
//  Unleash
//
//  Created by Louis Daily on 10/3/19.
//  Copyright © 2019 Silvercar. All rights reserved.
//

import Foundation
import PromiseKit

protocol Repeater {
  func attempt(action: @escaping () throws -> Void) throws
  func attempt(action: @escaping () -> Promise<Void>) -> Promise<Void>
}

class UnleashRepeater: Repeater {
  
  // MARK: Properties
  private var maxAttempts: Int
  private var delayBeforeRetry: TimeInterval
  private var attempts = 0
  private var scheduler: Scheduler {
    return UnleashScheduler.scheduler(interval: delayBeforeRetry, repeats: false)
  }
  
  // MARK: Init
  private init(maxAttempts: Int, delayBeforeRetry: TimeInterval) {
    self.maxAttempts = maxAttempts
    self.delayBeforeRetry = delayBeforeRetry
  }
  
  class func initialize(maxAttempts: Int = 3, delayBeforeRetry: TimeInterval = 60) -> UnleashRepeater {
    return UnleashRepeater(maxAttempts: maxAttempts, delayBeforeRetry: delayBeforeRetry)
  }
  
  // MARK: Methods
  func attempt(action: @escaping () throws -> Void) throws {
    self.attempts += 1
    do {
      try action()
    } catch let actionError {
      guard self.attempts < self.maxAttempts else { throw actionError }
      scheduler.do { try self.attempt(action: action) }.start()
    }
  }
  
  @discardableResult
  func attempt<T>(action: @escaping () -> Promise<T>) -> Promise<T> {
    func attempt() -> Promise<T> {
      self.attempts += 1
      return action()
      .recover { error -> Promise<T> in
        guard self.attempts < self.maxAttempts else { throw error }
        return after(seconds: self.delayBeforeRetry).then(on: nil) { _ in return attempt() }
      }
    }
    return attempt()
  }
}
