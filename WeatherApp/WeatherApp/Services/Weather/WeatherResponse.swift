//
//  WeatherResponse.swift
//  WeatherApp
//
//  Created by Evgenii Rtischev on 25.04.2022.
//

import Foundation

struct WeatherResponse {
    let daily: [Weather]
}

extension WeatherResponse: Codable {

    private enum Key: String, CodingKey {
        case daily
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
        daily = try container.decode([Weather].self, forKey: .daily)
    }
}
