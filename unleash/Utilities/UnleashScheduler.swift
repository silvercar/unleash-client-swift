//
//  UnleashScheduler.swift
//  Unleash
//
//  Created by Louis Daily on 9/27/19.
//  Copyright © 2019 Silvercar. All rights reserved.
//

import Foundation
import PromiseKit

protocol Scheduler {
  var delay: TimeInterval { get }
  var interval: TimeInterval { get }
  var maxAttempts: Int? { get }
  var attempts: Int { get }
  var delegate: SchedulerDelegate? { get set }
  
  static func after(_ delay: TimeInterval, repeating interval: TimeInterval, maxAttempts: Int?) -> Scheduler
  static func every(interval: TimeInterval, maxAttempts: Int?) -> Scheduler
  func `do`(_ action: @escaping () throws -> Void)
  func resume()
  func suspend()
  func cancel()
}

protocol SchedulerDelegate {
  func schedulerDidFail(_ scheduler: Scheduler, withError error: Error)
}

class UnleashScheduler: Scheduler {
  
  // MARK: Scheduler State
  enum State {
    case cancelled
    case resumed
    case suspended
  }
  
  // MARK: Properties
  let delay: TimeInterval
  let interval: TimeInterval
  let maxAttempts: Int?
  var delegate: SchedulerDelegate?
  private var timer: DispatchSourceTimer?
  private(set) var state: State = .suspended
  private(set) var attempts = 0
  
  // MARK: Init
  private init(delay: TimeInterval = 0, interval: TimeInterval = 0, maxAttempts: Int? = nil) {
    self.delay = delay
    self.interval = interval
    self.maxAttempts = maxAttempts
  }
  
  // MARK: Static Methods
  static func after(_ delay: TimeInterval = 0, repeating interval: TimeInterval = 0, maxAttempts: Int? = nil) -> Scheduler {
    return UnleashScheduler(delay: delay, interval: interval, maxAttempts: maxAttempts)
  }
  
  static func every(interval: TimeInterval, maxAttempts: Int? = nil) -> Scheduler {
    return UnleashScheduler(interval: interval, maxAttempts: maxAttempts)
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
        guard let self = self else { return }
        if let maxAttempts = self.maxAttempts {
          if self.attempts < maxAttempts {
            self.cancel()
            self.delegate?.schedulerDidFail(self, withError: error)
          }
        } else {
          self.delegate?.schedulerDidFail(self, withError: error)
        }
      }
    }
    resume()
  }
  
  func `do`(_ action: @escaping () throws -> Void) {
    schedule(action)
  }
  
  func resume() {
    guard state != .resumed else { return }
    state = .resumed
    timer?.resume()
  }
  
  func suspend() {
    guard state != .suspended else { return }
    state = .suspended
    timer?.suspend()
  }
  
  func cancel() {
    timer?.setEventHandler {}
    if state == .suspended {
      timer?.resume()
    }
    state = .cancelled
    timer?.cancel()
  }
}
