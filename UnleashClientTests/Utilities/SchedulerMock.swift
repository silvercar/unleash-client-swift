//
//  SchedulerMock.swift
//  UnleashTests
//
//  Created by Louis Daily on 10/7/19.
//  Copyright © 2019 Silvercar. All rights reserved.
//

import Foundation
@testable import Unleash

class SchedulerMock: UnleashScheduler {}

class SchedulerDelegateMock: SchedulerDelegate {
  private(set) var unleashError: UnleashError?
  private(set) var error: Error?
  
  func schedulerDidFail(_ scheduler: Scheduler, withError error: Error) {
    switch error {
    case let error as UnleashError:
      unleashError = error
    default:
      self.error = error
    }
  }
}
