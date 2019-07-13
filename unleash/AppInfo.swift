//
//  AppInfo.swift
//  Unleash
//
//  Copyright © 2019 Silvercar. All rights reserved.
//

import Foundation

public enum AppInfo {
    public static let shortVersion =
        Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? ""
}
