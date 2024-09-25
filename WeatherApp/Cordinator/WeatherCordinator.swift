//
//  WeatherCordinator.swift
//  WeatherApp
//
//  Created by Alina Sadiq on 9/25/24.
//

import SwiftUI

// Coordinator responsible for managing the weather feature

class WeatherCoordinator: Coordinator {
    func start() -> AnyView {
        // Create an instance of WeatherViewModel with WeatherService
        let viewModel = WeatherViewModel(weatherService: WeatherService())
        // Return the WeatherView with the created ViewModel
        return AnyView(WeatherView(viewModel: viewModel))
    }
}
