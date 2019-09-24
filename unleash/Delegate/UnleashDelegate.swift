//
//  UnleashDelegate.swift
//  Unleash
//
//  Created by Louis Daily on 9/24/19.
//  Copyright © 2019 Silvercar. All rights reserved.
//

import Foundation

// MARK: - UnleashDelegate
public protocol UnleashDelegate: AnyObject {
  func unleashDidFetchToggles(_ unleash: Unleash)
  func unleash(_ unleash: Unleash, didFailWithError error: Error)
}
