//
//  WeatherPresentation.swift
//  WeatherApp
//
//  Created by Evgenii Rtischev on 25.04.2022.
//

import Foundation

// fast solution, better use full V–>I–>P
struct WeatherPresentation {
    
    let morningTemp: String
    let dayTemp: String
    let nightTemp: String
    let day: String

    private static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE dd/MM"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        return dateFormatter
    }()

    init (from weather: Weather, dayFromToday: Int) {
        morningTemp = String(format: "%.0f", weather.morningTemp ?? "")
        dayTemp = String(format: "%.0f", weather.dayTemp ?? "")
        nightTemp = String(format: "%.0f", weather.nightTemp ?? "")
        day = Self.dateFormatter.string(from: Date(timeIntervalSinceNow: 86400 * Double(dayFromToday)))
    }
}

