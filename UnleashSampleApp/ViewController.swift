//
//  ViewController.swift
//  UnleashSampleApp
//
//  Copyright © 2019 Silvercar. All rights reserved.
//

import UIKit
import Unleash

// This constant is to emulate a client knowing its target environment is (e.g. QA, Production)
struct Constants {
  static let environment: String = "QA"
}

class ViewController: UIViewController {
  //MARK: Properties
  @IBOutlet internal var isFeatureEnabled: UILabel!
  @IBOutlet internal var activityIndicator: UIActivityIndicatorView!
  private var isLoading: Bool = false {
    didSet {
      isLoading
      ? activityIndicator.startAnimating()
      : activityIndicator.stopAnimating()
    }
  }
  private var unleash: Unleash!
  
  // MARK: - View Lifecycle
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    isLoading = true
    unleash = Unleash(
      appName: "ios-unleash-sample-app",
      url: "https://unleash.silvercar.com/api",
      refreshInterval: 10,
      strategies: [EnvironmentStrategy()])
    isLoading = false
    isFeatureEnabled.text = "\(unleash.isEnabled(name: "enable-auth0-in-admin-client"))"
  }
  
  @IBAction func didTapRefresh(_ sender: UIButton) {
    isFeatureEnabled.text = ""
    isLoading = true
    isFeatureEnabled.text = "\(unleash.isEnabled(name: "enable-auth0-in-admin-client"))"
    isLoading = false
  }
}

// MARK: - EnvironmentStrategy
class EnvironmentStrategy: Strategy {    
  var name: String {
    return "environment"
  }
  
  func isEnabled(parameters: [String : String]) -> Bool {
    return Constants.environment == parameters["environment"]
  }
}

