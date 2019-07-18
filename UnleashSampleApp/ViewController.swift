//
//  ViewController.swift
//  UnleashSampleApp
//
//  Copyright © 2019 Silvercar. All rights reserved.
//

import UIKit
import Unleash

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        _ = Unleash(appName: "rac-web-admin-dev",
                    url: "https://unleash.silvercar.com/api",
                    refreshInterval: 300000,
                    strategies: [EnvironmentStrategy()])
    }
}

class EnvironmentStrategy: Strategy {    
    var name: String {
        return "environment"
    }
    
    func isEnabled(parameters: [String : String]) -> Bool {
        return false
    }
}
