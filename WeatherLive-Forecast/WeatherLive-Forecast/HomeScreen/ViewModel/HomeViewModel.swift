//
//  HomeViewModel.swift
//  WeatherLive-Forecast
//
//  Created by Prajwal rao Kadam J on 23/10/24.
//

import Foundation

protocol HomeScreenDataProtocol: AnyObject {
    func sendHomeScreenData(data: CityWeatherDetailsModel, weatherItems: [WeatherItem], isFromSearch: Bool)
    func showLoader()
    func hideLoader()
    func handleError(_ error: Error)
}
class HomeViewModel {
    
    var view: HomeScreenDataProtocol
    private let urlBuilder = URLBuilder()
    let apiKeyManager = APIKeyManager()
    private var apiKey: String = ""
    
    private var  cityWeatherDetails: WeatherResponse?
    
    
    init(_ view: HomeScreenDataProtocol) {
        self.view = view
    }
    
    
    private func retreiveApiKey() {
        self.apiKey = self.apiKeyManager.retreiveApiKey()
        if apiKey.isEmpty {
            view.handleError(HomeViewModelError.apiKeyMissing)
        }
    }
    
    
    func getHomeScreenWeatherData(latitude: Double, longitude: Double) {
        retreiveApiKey()
       // view.showLoader()
        guard let weatherURL = urlBuilder
            .setEndpoint("weather")
            .addQueryParameter(key: "lat", value: String(describing: latitude))
            .addQueryParameter(key: "lon", value: String(describing: longitude))
            .addQueryParameter(key: "appid", value: apiKey)
            .build() else {
            view.hideLoader()
            view.handleError(HomeViewModelError.invalidURL)
            return
        }
        print(weatherURL)
        NetworkManager.shared.fetchData(from: weatherURL, model: WeatherResponse.self) { result in
            DispatchQueue.main.async { [weak self] in
                
                guard let strongSelf = self else { return }
                strongSelf.view.hideLoader()
                switch result {
                case .success(let weatherResponse):
                    print("Weather data: \(weatherResponse)")
                    print("City: \(weatherResponse.name)")
                    strongSelf.cityWeatherDetails = weatherResponse
                    let cityDetails = strongSelf.sendCityDetailsData(data: weatherResponse)
                    let weatherItems = strongSelf.getWeatherDetails( from: weatherResponse)
                    strongSelf.view.sendHomeScreenData(data: cityDetails, weatherItems: weatherItems, isFromSearch: false)
                case .failure(let error):
                    print("Error fetching weather data: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func sendCityDetailsData(data: WeatherResponse) -> CityWeatherDetailsModel {
        let temperature = data.main.temp
        let temperatureInCelcius =  CommonMethods.shared.kelvinToCelsius(kelvin: temperature)
        return CityWeatherDetailsModel(cityName: data.name, temperature:  temperatureInCelcius, weatherDescription: data.weather.first?.description ?? "", weatherImage: getWeatherImageNameBasedOnWeatherCondition(weatherCondition: data.weather.first?.main ?? ""))
    }
    
    func getWeatherDetails(from weatherResponse: WeatherResponse) -> [WeatherItem] {
        return [
            WeatherItem(title: "Pressure", value: "\(weatherResponse.main.pressure)", unit: "hPa", imageName: "pressure"),
            WeatherItem(title: "Min Temp", value: "\(Int(weatherResponse.main.temp_min - 273.15))", unit: "°C", imageName: "temperature"),
            WeatherItem(title: "Max Temp", value: "\(Int(weatherResponse.main.temp_max - 273.15))", unit: "°C", imageName: "temperature"),
            WeatherItem(title: "Humidity", value: "\(weatherResponse.main.humidity)", unit: "%", imageName: "humidity"),
            WeatherItem(title: "Description", value: weatherResponse.weather.first?.description.capitalized ?? "", unit: "", imageName: "clouds")
        ]
    }
    
    func getWeatherImageNameBasedOnWeatherCondition(weatherCondition: String) -> String {
        if let imageName = WeatherType.imageName(for: weatherCondition) {
            return imageName
        } else {
            print("Weather type not found.")
            return ""
        }
    }
    
    // Custom error enum for specific error cases
    enum HomeViewModelError: LocalizedError {
        case invalidURL
        case apiKeyMissing
        case invalidResponse
        
        var errorDescription: String? {
            switch self {
            case .invalidURL:
                return "Invalid URL configuration"
            case .apiKeyMissing:
                return "API key is missing"
            case .invalidResponse:
                return "Invalid response from server"
            }
        }
    }
    
    
    func getWeatherData(cityName: String) {
        retreiveApiKey()
        view.showLoader()
        guard let weatherURL = urlBuilder
            .setEndpoint("weather")
            .addQueryParameter(key: "q", value: String(describing: cityName))
            .addQueryParameter(key: "appid", value: apiKey)
            .build() else {
            view.hideLoader()
            view.handleError(HomeViewModelError.invalidURL)
            return
        }
        NetworkManager.shared.fetchData(from: weatherURL, model: WeatherResponse.self) { result in
            DispatchQueue.main.async { [weak self] in
                
                guard let strongSelf = self else { return }
                strongSelf.view.hideLoader()
                switch result {
                case .success(let weatherResponse):
                    print("Weather data: \(weatherResponse)")
                    print("City: \(weatherResponse.name)")
                    strongSelf.cityWeatherDetails = weatherResponse
                    let cityDetails = strongSelf.sendCityDetailsData(data: weatherResponse)
                    let weatherItems = strongSelf.getWeatherDetails( from: weatherResponse)
                    strongSelf.view.sendHomeScreenData(data: cityDetails, weatherItems: weatherItems, isFromSearch: true)
                case .failure(let error):
                    print("Error fetching weather data: \(error.localizedDescription)")
                }
            }
        }
    }
}


extension HomeViewModel: SendRetreivedApiKey {
    
    func sendApiKey(key: String) {
        
        self.apiKey = key
        
    }
}
