//
//  LocationProvider.swift
//  WeatherApp
//
//  Created by Evgenii Rtischev on 25.04.2022.
//

import Foundation
import CoreLocation

enum LocationError {
    case disabledByUser
}

extension LocationError: LocalizedError {

    var errorDescription: String? {
        switch self {
        case .disabledByUser:
            return "Location is disabled. Please go to the Settings app and enable id."
        }
    }
}

typealias LocationProviderResult = Result<(Double, Double), Error>

protocol LocationProviderProtocol {
    func get(_ completion:@escaping (LocationProviderResult) -> Void)
}

final class LocationProvider: NSObject {
    private lazy var locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.delegate = self
        return locationManager
    }()

    private var completion: ((LocationProviderResult) -> Void)?
}

extension LocationProvider: LocationProviderProtocol {
    func get(_ completion: @escaping ((LocationProviderResult) -> Void)) {
        self.completion = completion
        if (locationManager.authorizationStatus == .authorizedAlways) || (locationManager.authorizationStatus == .authorizedWhenInUse) {
            locationManager.requestLocation()
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
}

extension LocationProvider: CLLocationManagerDelegate {

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if (manager.authorizationStatus == .authorizedAlways) || (manager.authorizationStatus == .authorizedWhenInUse) {
            locationManager.requestLocation()
        } else if (manager.authorizationStatus == .restricted) || (manager.authorizationStatus == .denied) {
            completion?(.failure(LocationError.disabledByUser))
        }
    }


    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            print("User's location is \(latitude)", "\(longitude)")
            completion?(.success((latitude, longitude)))
        }
    }

    func locationManager(
        _ manager: CLLocationManager,
        didFailWithError error: Error
    ) {
        completion?(.failure(error))
    }

}

