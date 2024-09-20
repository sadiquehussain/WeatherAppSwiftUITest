//
//  WaetherModel.swift
//  WeatherApp
//
//  Created by Alina Sadiq on 9/19/24.
//

import Foundation

struct WeatherResponse: Codable {
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main: Codable {
    let temp: Double
}

struct Weather: Codable {
    let description: String
    let icon: String
}
