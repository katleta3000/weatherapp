//
//  WeatherProvider.swift
//  WeatherApp
//
//  Created by Evgenii Rtischev on 25.04.2022.
//

import Foundation

enum WeatherProviderError: Error {
    case serverError
    case serializationError
}

protocol WeatherProviderProtocol {
    func getLast(completion: @escaping ([Weather]) -> Void)
    func get(for location: (lat: Double, lon: Double), completion: @escaping (Result<[Weather], Error>) -> Void)
}

final class WeatherProvider {
    private let apiKey = "a1d2efac3ae33f7dd1664f423b9d081d"
    private let storageKey = "Weather.Last.Cached"
}

extension WeatherProvider: WeatherProviderProtocol {

    func getLast(completion: @escaping ([Weather]) -> Void) {
        if
            let data = UserDefaults.standard.object(forKey: storageKey) as? Data,
            let weather = try? PropertyListDecoder().decode([Weather].self, from: data) {
            completion(weather)
        } else {
            completion([])
        }
    }

    func get(for location: (lat: Double, lon: Double), completion: @escaping (Result<[Weather], Error>) -> Void) {
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/onecall?lat=\(location.lat)&lon=\(location.lon)&exclude=current,minutely,hourly,alerts&appid=\(apiKey)&units=metric") else { return }
        // And injection later
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let someError = error {
                completion(.failure(someError))
            } else if
                let httpResponse = response as? HTTPURLResponse,
                (200..<299).contains(httpResponse.statusCode),
                let body = data {
                do {
                    let weather = try self.serializeWeather(from: body)
                    // basically we may use here HTTP Protocol Cache if we may control our backend to set policy
                    self.save(weather)
                    completion(.success(weather))
                }
                catch let error {
                    completion(.failure(error))
                }
            } else {
                completion(.failure(WeatherProviderError.serverError))
            }
        }.resume()
    }

}

private extension WeatherProvider {

    func serializeWeather(from data: Data) throws -> [Weather] {
        let decoder = JSONDecoder()
        do {
            let response = try decoder.decode(WeatherResponse.self, from: data)
            return response.daily
        } catch let error {
            throw error
        }
    }

    func save(_ weather: [Weather]) {
        do {
            try UserDefaults.standard.set(
                PropertyListEncoder().encode(weather),
                forKey: storageKey
            )
            UserDefaults.standard.synchronize() // for simulator only
        } catch let error {
            print(error.localizedDescription)
        }
    }
}
