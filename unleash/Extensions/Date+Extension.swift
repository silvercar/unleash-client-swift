//
//  Date+Extension.swift
//  Unleash
//
//  Copyright © 2019 Silvercar. All rights reserved.
//

import Foundation

public extension Date {
    var iso8601DateString: String {
        return DateFormatter.iso8601DateFormatter.string(from: self)
    }
}

extension DateFormatter {
    fileprivate static var iso8601DateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: "GMT")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        return formatter
    }
}
