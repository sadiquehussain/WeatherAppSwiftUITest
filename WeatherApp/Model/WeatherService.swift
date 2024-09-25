//
//  WeatherService.swift
//  WeatherApp
//
//  Created by Alina Sadiq on 9/19/24.
//

import Foundation

// Service class for fetching weather data from an API

protocol WeatherServiceProtocol {
    func fetchWeather(for city: String, completion: @escaping (Result<WeatherResponse, Error>) -> Void)
}

class WeatherService: WeatherServiceProtocol {
    private let apiKey = "6639e4800a932e56c6037d6971313b9b"

    func fetchWeather(for city: String, completion: @escaping (Result<WeatherResponse, Error>) -> Void) {
        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(apiKey)&units=metric"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 400, userInfo: nil)))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: 500, userInfo: nil)))
                return
            }
            
            do {
                let weatherData = try JSONDecoder().decode(WeatherResponse.self, from: data)
                completion(.success(weatherData))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
