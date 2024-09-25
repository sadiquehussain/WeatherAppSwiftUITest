import SwiftUI
import Foundation
import CoreLocation
import UIKit

@main
struct WeatherApp: App {
    var body: some Scene {
        WindowGroup {
            // Start the app with the WeatherCoordinator
            WeatherCoordinator().start()
        }
    }
}
