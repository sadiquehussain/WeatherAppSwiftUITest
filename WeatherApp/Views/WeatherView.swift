//
//  WeatherView.swift
//  WeatherApp
//
//  Created by Alina Sadiq on 9/25/24.
//

import SwiftUI

struct WeatherView: View {
    @ObservedObject var viewModel: WeatherViewModel
    @State private var city: String = ""
    
    private let lastCityKey = "lastCity"

    var body: some View {
        ZStack {
            // Background Color
            Color.blue.opacity(0.1)
                .edgesIgnoringSafeArea(.all) // Fill the background
            
            VStack(spacing: 20) {
                // Title
                Text("Weather App")
                    .font(.largeTitle)
                    .bold()
                    .padding(.top, 50)
                
                // TextField for entering city name
                TextField("Enter city", text: $city)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    .padding(.horizontal)
                    .onAppear {
                        loadLastCity() // Load the last city when the view appears
                    }
                
                // Button to fetch weather data
                Button(action: {
                    viewModel.fetchWeather(for: city) // Fetch weather for the entered city
                    saveLastCity() // Save the last city entered
                }) {
                    Text("Get Weather")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                }
                .padding(.horizontal)
                
                // Display error message if exists
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                } else {
                    // Weather Information Card
                    if let weather = viewModel.weatherData {
                        VStack(spacing: 10) {
                            Text(viewModel.getWeatherDescription())
                                .font(.title)
                                .bold()
                            
                            if let iconURL = viewModel.getWeatherIconURL() {
                                AsyncImage(url: iconURL) { image in
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 100, height: 100)
                                        .cornerRadius(10)
                                        .shadow(radius: 5)
                                } placeholder: {
                                    ProgressView() // Show loading indicator while fetching the icon
                                        .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                                }
                            }
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(radius: 10)
                        .padding(.horizontal)
                    }
                }
            }
        }
        .padding()
    }

    // Function to save the last entered city to UserDefaults
    private func saveLastCity() {
        UserDefaults.standard.setValue(city, forKey: lastCityKey)
    }

    // Function to load the last entered city from UserDefaults
    private func loadLastCity() {
        if let lastCity = UserDefaults.standard.string(forKey: lastCityKey) {
            city = lastCity // Set the city text field
            viewModel.fetchWeather(for: lastCity) // Fetch weather for the last city
        }
    }
}
