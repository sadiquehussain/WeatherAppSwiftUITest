//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Alina Sadiq on 9/19/24.
//

import Foundation

class WeatherViewModel: ObservableObject {
    @Published var weatherData: WeatherResponse?
    @Published var errorMessage: String?

    private let weatherService: WeatherServiceProtocol

    init(weatherService: WeatherServiceProtocol) {
        self.weatherService = weatherService
    }

    func fetchWeather(for city: String) {
        weatherService.fetchWeather(for: city) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    self?.weatherData = data
                    self?.errorMessage = nil
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }

    func getWeatherDescription() -> String {
        guard let weatherData = weatherData else { return "Please enter a valid location" }
        let cityName = weatherData.name
        let temperature = weatherData.main.temp
        let description = weatherData.weather.first?.description ?? ""
        return "Weather in \(cityName): \(temperature)°C, \(description)"
    }

    func getWeatherIconURL() -> URL? {
        guard let iconCode = weatherData?.weather.first?.icon else { return nil }
        let iconUrlString = "http://openweathermap.org/img/wn/\(iconCode)@2x.png"
        return URL(string: iconUrlString)
    }
    
     func cacheLastCity(city: String) {
           UserDefaults.standard.setValue(city, forKey: "lastCity")
       }
}
