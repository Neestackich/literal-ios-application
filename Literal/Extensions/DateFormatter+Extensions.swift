//
//  DateFormatter+Extensions.swift
//  Literal
//
//  Created by Neestackich on 11.12.20.
//

import Foundation

extension DateFormatter {
    static let iso8601Full: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSz"
        dateFormatter.calendar = Calendar(identifier: .iso8601)
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")

        return dateFormatter
    }()

    static let YYYYMMDD: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        dateFormatter.calendar = Calendar(identifier: .iso8601)
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")

        return dateFormatter
    }()
}
