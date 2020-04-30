//
//  UnleashScheduler.swift
//  Unleash
//
//  Created by Louis Daily on 9/27/19.
//  Copyright © 2019 Silvercar. All rights reserved.
//

import Foundation
import PromiseKit

// MARK: Scheduler State
enum SchedulerState {
  case cancelled
  case resumed
  case suspended
}

protocol Scheduler {
  var delay: TimeInterval { get }
  var interval: TimeInterval { get }
  var maxAttempts: Int? { get }
  var attempts: Int { get }
  var delegate: SchedulerDelegate? { get set }
  var state: SchedulerState { get }
  
  static func after(delay: TimeInterval, repeatingInterval interval: TimeInterval, maxAttempts: Int?) -> Scheduler
  static func every(interval: TimeInterval, maxAttempts: Int?) -> Scheduler
  func `do`(_ action: @escaping () throws -> Void)
  func activate()
  func resume()
  func suspend()
  func cancel()
}

protocol SchedulerDelegate {
  func schedulerDidFail(_ scheduler: Scheduler, withError error: Error)
}

class UnleashScheduler: Scheduler {
  
  // MARK: Properties
  let delay: TimeInterval
  let interval: TimeInterval
  let maxAttempts: Int?
  var delegate: SchedulerDelegate?
  private var timer: DispatchSourceTimer?
  private(set) var state: SchedulerState = .suspended
  private(set) var attempts = 0
  
  // MARK: Init
  private init(delay: TimeInterval, interval: TimeInterval, maxAttempts: Int?) {
    self.delay = delay
    self.interval = interval
    self.maxAttempts = maxAttempts
  }
  
  deinit {
    if state != .resumed && state != .cancelled {
      // Needs to be resumed so timer can be deallocated appropriately, as mentioned in docs.
      timer?.resume()
    }
  }
  
  // MARK: Static Methods
  class func after(delay: TimeInterval = 0, repeatingInterval interval: TimeInterval = 0, maxAttempts: Int? = nil) -> Scheduler {
    return UnleashScheduler(delay: delay, interval: interval, maxAttempts: maxAttempts)
  }
  
  class func every(interval: TimeInterval = 0, maxAttempts: Int? = nil) -> Scheduler {
    return UnleashScheduler(delay: 0, interval: interval, maxAttempts: maxAttempts)
  }
  
  // MARK: - Methods
  private func schedule(_ action: @escaping () throws -> Void) {
    timer?.cancel()
    timer = DispatchSource.makeTimerSource(flags: .init(), queue: .global(qos: .utility))
    timer?.schedule(deadline: .now() + delay, repeating: interval)
    timer?.setEventHandler { [weak self] in
      do {
        try action()
      } catch {
        if let self = self {
          self.attempts += 1
          if let maxAttempts = self.maxAttempts {
            if self.attempts >= maxAttempts {
              self.delegate?.schedulerDidFail(self, withError: error)
              self.cancel()
            }
          } else {
            self.delegate?.schedulerDidFail(self, withError: error)
          }
        }
      }
    }
  }
  
  func `do`(_ action: @escaping () throws -> Void) {
    schedule(action)
  }
  
  func activate() {
    if state != .resumed {
      state = .resumed
      timer?.activate()
    }
  }
  
  func resume() {
    if state != .resumed {
      state = .resumed
      timer?.resume()
    }
  }
  
  func suspend() {
    if state != .suspended {
      state = .suspended
      timer?.suspend()
    }
  }
  
  func cancel() {
    if state == .suspended {
      resume()
    }
    state = .cancelled
    timer?.cancel()
  }
}
