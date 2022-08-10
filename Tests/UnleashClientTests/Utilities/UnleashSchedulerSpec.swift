//
//  UnleashSchedulerSpec.swift
//  UnleashTests
//
//  Created by Louis Daily on 10/3/19.
//  Copyright © 2019 Silvercar. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import UnleashClient

class UnleashSchedulerSpec: QuickSpec {
  
  override func spec() {
    
    describe("#after") {
      context("when using default arguments") {
        it("should return default scheduler") {
          // Act
          var scheduler = UnleashScheduler.after()
          
          // Assert
          expect(scheduler.delay).to(equal(0))
          expect(scheduler.interval).to(equal(0))
          expect(scheduler.maxAttempts).to(beNil())
        }
      }
      
      context("when passing in maxAttempts argument") {
        it("should set maxAttempts for scheduler") {
          // Act
          var scheduler = UnleashScheduler.after(maxAttempts: 3)
          
          // Assert
          expect(scheduler.maxAttempts).to(equal(3))
        }
      }
    }
    
    describe("#every") {
      context("when using default arguments") {
        it("should return default scheduler") {
          // Act
          var scheduler = UnleashScheduler.every()
          
          // Assert
          expect(scheduler.delay).to(equal(0))
          expect(scheduler.interval).to(equal(0))
          expect(scheduler.maxAttempts).to(beNil())
        }
      }
      
      context("when setting interval") {
        it("should set scheduler interval only") {
          // Act
          var scheduler = UnleashScheduler.every(interval: 5)
          
          // Assert
          expect(scheduler.delay).toNot(equal(5))
          expect(scheduler.interval).to(equal(5))
        }
      }
    }
    
    describe("#do") {
      context("when setting an action") {
        it("should schedule and set state to resumed") {
          // Assemble
          let scheduler = UnleashScheduler.every()
          
          // Act
          scheduler.do { print("") }
          scheduler.activate()
          
          // Assert
          expect(scheduler.state).to(equal(.resumed))
        }
      }
      
      context("when setting a failing action") {
        it("should call delegate schedulerDidFail method") {
          var scheduler = UnleashScheduler.every()
          
          // Act
          let schedulerDelegateMock = SchedulerDelegateMock()
          scheduler.delegate = schedulerDelegateMock
          scheduler.do {
            throw UnleashError.noURLProvided
          }
          scheduler.activate()
          
          expect(schedulerDelegateMock.unleashError)
            .toEventually(equal(.noURLProvided))
        }
      }
      
      context("when has max attempt limit") {
        context("has failed for max attempts") {
          it("should call delegate schedulerDidFail method") {
            var scheduler = UnleashScheduler.every(interval: 0, maxAttempts: 3)
            
            // Act
            let schedulerDelegateMock = SchedulerDelegateMock()
            scheduler.delegate = schedulerDelegateMock
            scheduler.do {
              throw UnleashError.maxRetriesReached
            }
            scheduler.activate()
            expect(schedulerDelegateMock.unleashError)
              .toEventually(equal(.maxRetriesReached))
          }
        }
      }
    }
    
    describe("#suspend") {
      context("when suspending an action that is not in the suspend state") {
        it("should set state to suspend") {
          // Assemble
          let scheduler = UnleashScheduler.every()
          
          // Act
          scheduler.do { print("") }
          scheduler.activate()
          expect(scheduler.state).to(equal(.resumed))
          scheduler.suspend()
          
          // Assert
          expect(scheduler.state).to(equal(.suspended))
        }
      }
    }
    
    describe("#cancel") {
      context("when cancelling a suspended action") {
        it("should cancel successfully") {
          // Assemble
          let scheduler = UnleashScheduler.every()
          
          // Act
          scheduler.do { print("") }
          scheduler.activate()
          scheduler.suspend()
          scheduler.cancel()
          
          // Assert
          expect(scheduler.state).to(equal(.cancelled))
        }
      }
    }
  }
}
