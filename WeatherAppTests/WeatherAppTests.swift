import XCTest
import Combine
@testable import WeatherApp

class WeatherViewModelTests: XCTestCase {
    var viewModel: WeatherViewModel!
    var weatherServiceMock: WeatherServiceMock!
    var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        weatherServiceMock = WeatherServiceMock()
        viewModel = WeatherViewModel(weatherService: weatherServiceMock)
        cancellables = []
    }

    override func tearDown() {
        viewModel = nil
        weatherServiceMock = nil
        cancellables = nil
        super.tearDown()
    }

    func testFetchWeatherSuccess() {
        // Given
        let expectedCity = "London"
        let expectedWeatherResponse = WeatherResponse(
            name: expectedCity,
            main: Main(temp: 20.0),
            weather: [Weather(description: "Clear", icon: "01d")]
        )
        weatherServiceMock.mockResponse = .success(expectedWeatherResponse)

        // When
        viewModel.fetchWeather(for: expectedCity)

        // Then
        let expectation = self.expectation(description: "Weather fetched")
        viewModel.$weatherData
            .dropFirst() // Skip initial nil
            .sink { weatherData in
                XCTAssertNotNil(weatherData)
                XCTAssertEqual(weatherData?.name, expectedCity)
                XCTAssertEqual(weatherData?.main.temp, 20.0)
                XCTAssertEqual(weatherData?.weather.first?.description, "Clear")
                expectation.fulfill()
            }
            .store(in: &cancellables)

        waitForExpectations(timeout: 1, handler: nil)
    }

    func testFetchWeatherFailure() {
        // Given
        let expectedCity = "InvalidCity"
        weatherServiceMock.mockResponse = .failure(NSError(domain: "TestError", code: 500, userInfo: nil))

        // When
        viewModel.fetchWeather(for: expectedCity)

        // Then
        let expectation = self.expectation(description: "Error message received")
        viewModel.$errorMessage
            .dropFirst() // Skip initial nil
            .sink { errorMessage in
                XCTAssertEqual(errorMessage, "The operation couldn’t be completed. (TestError error 500.)")
                expectation.fulfill()
            }
            .store(in: &cancellables)

        waitForExpectations(timeout: 1, handler: nil)
    }
}

class WeatherServiceMock: WeatherServiceProtocol {
    var mockResponse: Result<WeatherResponse, Error>!

    func fetchWeather(for city: String, completion: @escaping (Result<WeatherResponse, Error>) -> Void) {
        completion(mockResponse)
    }
}
