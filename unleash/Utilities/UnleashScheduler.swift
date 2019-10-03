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
  func `do`(_ execute: @escaping () throws -> Void) -> Scheduler
  func start()
  func cancel()
}

final class UnleashScheduler: Scheduler {
  
  // MARK: - Properties
  private var interval: TimeInterval = 86400
  private var repeats: Bool = false
  private var timer: Timer?
  private(set) var failureCount = 0
  
  // MARK: - Init
  private init(interval: TimeInterval = 86400, repeats: Bool = false) {
    self.interval = interval
    self.repeats = repeats
  }
  
  static func scheduler(interval: TimeInterval = 86400, repeats: Bool = false) -> UnleashScheduler {
    return UnleashScheduler(interval: interval, repeats: repeats)
  }
  
  // MARK: - Methods
  func `do`(_ execute: @escaping () throws -> Void) -> Scheduler {
    guard timer == nil else { fatalError("Should not override already defined timer.") }
    
    self.timer = Timer(timeInterval: interval, repeats: repeats, block: { [weak self] _ in
      do {
        try execute()
      } catch {
        self?.failureCount += 1
      }
    })
    return self
  }
  
  private func commonStart() {
    guard
      let timer = self.timer,
      timer.isValid
      else { return }
    RunLoop.current.add(timer, forMode: .common)
    timer.fire()
  }
  
  private func commonCancel() {
    guard
      let timer = self.timer,
      timer.isValid
      else { return }
    timer.invalidate()
    self.timer = nil
  }
  
  func start() {
    commonStart()
  }
  
  func cancel() {
    commonCancel()
  }
}