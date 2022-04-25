//
//  ServiceLocator.swift
//  WeatherApp
//
//  Created by Evgenii Rtischev on 25.04.2022.
//

import Foundation

final class ServiceLocator {

    static let shared = ServiceLocator()

    lazy var weatherProvider: WeatherProviderProtocol = WeatherProvider()
    lazy var locationProvider: LocationProviderProtocol = LocationProvider()
}
