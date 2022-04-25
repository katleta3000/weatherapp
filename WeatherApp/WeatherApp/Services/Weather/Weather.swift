//
//  Weather.swift
//  WeatherApp
//
//  Created by Evgenii Rtischev on 25.04.2022.
//

import Foundation

struct Weather: Codable {
    let morningTemp: Double?
    let dayTemp: Double?
    let nightTemp: Double?

    private enum Key: String, CodingKey {
        case temp
        case morningTemp
        case dayTemp
        case nightTemp
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
        if let tempDict = try? container.decode(Dictionary<String, Double>.self, forKey: .temp) {
            morningTemp = tempDict["morn"]
            dayTemp = tempDict["day"]
            nightTemp = tempDict["night"]
        } else {
            morningTemp = try container.decode(Double.self, forKey: .morningTemp)
            dayTemp = try container.decode(Double.self, forKey: .dayTemp)
            nightTemp = try container.decode(Double.self, forKey: .nightTemp)
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Key.self)
        try container.encode(morningTemp, forKey: .morningTemp)
        try container.encode(dayTemp, forKey: .dayTemp)
        try container.encode(nightTemp, forKey: .nightTemp)
    }
}

