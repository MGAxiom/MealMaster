//
//  Extensions.swift
//  MealMaster
//
//  Created by Maxime Girard on 31/07/2023.
//

import Foundation

extension Formatter {
    static let date: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .iso8601)
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "EE, MMM d, yy"
        return dateFormatter
    }()
}

extension Date {
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
}
