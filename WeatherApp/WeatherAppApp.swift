import SwiftUI
import Foundation
import CoreLocation
import UIKit

@main
struct WeatherApp: App {
    var body: some Scene {
        WindowGroup {
            WeatherCoordinator().start()
        }
    }
}

protocol Coordinator {
    func start() -> AnyView
}

class WeatherCoordinator: Coordinator {
    func start() -> AnyView {
        let viewModel = WeatherViewModel(weatherService: WeatherService())
        return AnyView(WeatherView(viewModel: viewModel))
    }
}

struct WeatherView: View {
    @ObservedObject var viewModel: WeatherViewModel
    @State private var city: String = ""
    
    private let lastCityKey = "lastCity"

    var body: some View {
        VStack {
            TextField("Enter city", text: $city)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .onAppear {
                    loadLastCity()
                }

            Button("Get Weather") {
                viewModel.fetchWeather(for: city)
                saveLastCity()
            }
            .padding()

            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage).foregroundColor(.red)
            } else {
                Text(viewModel.getWeatherDescription())
                if let iconURL = viewModel.getWeatherIconURL() {
                    AsyncImage(url: iconURL) { image in
                        image.resizable()
                             .aspectRatio(contentMode: .fit)
                             .frame(width: 100, height: 100)
                    } placeholder: {
                        ProgressView()
                    }
                }
            }
        }
        .padding()
    }

    private func saveLastCity() {
        UserDefaults.standard.setValue(city, forKey: lastCityKey)
    }

    private func loadLastCity() {
        if let lastCity = UserDefaults.standard.string(forKey: lastCityKey) {
            city = lastCity
            viewModel.fetchWeather(for: lastCity) // Fetch weather for the last city on load
        }
    }
}
