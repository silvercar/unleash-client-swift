//
//  ViewController.swift
//  UnleashSampleApp
//
//  Copyright © 2019 Silvercar. All rights reserved.
//

import UIKit
import Unleash

struct Constants {
  // This constant is to emulate a client knowing its target environment is (e.g. qa, stage, production)
  static let environment: String = "qa"
  static let appName = "ios-unleash-sample-app"
  static let unleashUrl = "https://unleash.silvercar.com/api"
  static let featureToggleName = "enable-ios-unleash-sample-app"
  static let errorTitle = "Unleash Error"
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
      appName: Constants.appName,
      url: Constants.unleashUrl,
      refreshInterval: 10,
      strategies: [EnvironmentStrategy()])
    unleash.delegate = self
  }
  
  private func refresh() {
    isFeatureEnabled.text = ""
    isLoading = true
    isFeatureEnabled.text = "\(unleash.isEnabled(name: Constants.featureToggleName))"
    isLoading = false
  }
}

// MARK: UnleashDelegate
extension ViewController: UnleashDelegate {
  func unleashDidLoad(_ unleash: Unleash) {
    refresh()
  }
  
  func unleashDidFail(_ unleash: Unleash, withError error: Error) {
    let alertController = UIAlertController(
      title: Constants.errorTitle,
      message: error.localizedDescription,
      preferredStyle: .alert)
    
    let action = UIAlertAction(title: "OK", style: .default, handler: nil)
    alertController.addAction(action)
    present(alertController, animated: true, completion: nil)
  }
}

// MARK: EnvironmentStrategy
class EnvironmentStrategy: Strategy {    
  var name: String {
    return "environment"
  }
  
  func isEnabled(parameters: [String : String]) -> Bool {
    return Constants.environment == parameters["environment"]
  }
}

