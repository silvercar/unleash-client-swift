//
//  Feature.swift
//  Unleash
//
//  Copyright © 2019 Silvercar. All rights reserved.
//

import Foundation

class Feature: Codable {
  var name: String
  var enabled: Bool
  var strategies: [ActivationStrategy]
  var variants: [VariantDefinition]?

  init(
    name: String,
    enabled: Bool,
    strategies: [ActivationStrategy],
    variants: [VariantDefinition]?
  ) {
    self.name = name
    self.enabled = enabled
    self.strategies = strategies
    self.variants = variants
  }
}
