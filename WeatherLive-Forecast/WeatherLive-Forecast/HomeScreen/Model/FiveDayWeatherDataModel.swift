//
//  FiveDayWeatherDataModel.swift
//  WeatherLive-Forecast
//
//  Created by Prajwal rao Kadam J on 27/10/24.
//

import Foundation

//struct ForecastResponse: Codable {
// let code: String
// let message: Int
// let count: Int
// let forecastItems: [ForecastItem]
// let location: Location
//}
//  
//struct ForecastItem: Codable {
// let timestamp: Int
// let conditions: Conditions
// let weatherConditions: [WeatherCondition]
// let cloudCover: CloudCover
// let windInfo: WindInfo
// let visibility: Int
// let precipitationProbability: Double
// let systemInfo: SystemInfo
// let dateText: String
//}
//  
//struct Conditions: Codable {
// let temperature: Double
// let feelsLikeTemperature: Double
// let minimumTemperature: Double
// let maximumTemperature: Double
// let pressure: Int
// let seaLevelPressure: Int
// let groundLevelPressure: Int
// let humidity: Int
// let temperatureChange: Double
//}
//  
//struct WeatherCondition: Codable {
// let identifier: Int
// let condition: String
// let description: String
// let icon: String
//}
//  
//struct CloudCover: Codable {
// let cloudiness: Int
//}
//  
//struct WindInfo: Codable {
// let speed: Double
// let direction: Int
// let gust: Double
//}
//  
//struct SystemInfo {
// let partOfDay: String
//}
//  
//struct Location {
// let identifier: Int
// let name: String
// let coordinates: Coordinates
// let country: String
// let population: Int
// let timezone: Int
// let sunrise: Int
// let sunset: Int
//}
//  
//struct Coordinates {
// let latitude: Double
// let longitude: Double
//}

struct ForecastResponse: Codable {
    let code: String
    let message: Int
    let count: Int
    let forecastItems: [ForecastItem]
    let location: Location
    
    enum CodingKeys: String, CodingKey {
        case code = "cod"
        case message
        case count = "cnt"
        case forecastItems = "list"
        case location = "city"
    }
}

struct ForecastItem: Codable {
    let timestamp: Int
    let conditions: Conditions
    let weatherConditions: [WeatherCondition]
    let cloudCover: CloudCover
    let windInfo: WindInfo
    let visibility: Int
    let precipitationProbability: Double
    let systemInfo: SystemInfo
    let dateText: String
    
    enum CodingKeys: String, CodingKey {
        case timestamp = "dt"
        case conditions = "main"
        case weatherConditions = "weather"
        case cloudCover = "clouds"
        case windInfo = "wind"
        case visibility
        case precipitationProbability = "pop"
        case systemInfo = "sys"
        case dateText = "dt_txt"
    }
}

struct Conditions: Codable {
    let temperature: Double
    let feelsLikeTemperature: Double
    let minimumTemperature: Double
    let maximumTemperature: Double
    let pressure: Int
    let seaLevelPressure: Int
    let groundLevelPressure: Int
    let humidity: Int
    let temperatureChange: Double
    
    enum CodingKeys: String, CodingKey {
        case temperature = "temp"
        case feelsLikeTemperature = "feels_like"
        case minimumTemperature = "temp_min"
        case maximumTemperature = "temp_max"
        case pressure
        case seaLevelPressure = "sea_level"
        case groundLevelPressure = "grnd_level"
        case humidity
        case temperatureChange = "temp_kf"
    }
}

struct WeatherCondition: Codable {
    let identifier: Int
    let condition: String
    let description: String
    let icon: String
    
    enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case condition = "main"
        case description
        case icon
    }
}

struct CloudCover: Codable {
    let cloudiness: Int
    
    enum CodingKeys: String, CodingKey {
        case cloudiness = "all"
    }
}

struct WindInfo: Codable {
    let speed: Double
    let direction: Int
    let gust: Double?
    
    enum CodingKeys: String, CodingKey {
        case speed
        case direction = "deg"
        case gust
    }
}

struct SystemInfo: Codable {
    let partOfDay: String
    
    enum CodingKeys: String, CodingKey {
        case partOfDay = "pod"
    }
}

struct Location: Codable {
    let identifier: Int
    let name: String
    let coordinates: Coordinates
    let country: String
    let population: Int
    let timezone: Int
    let sunrise: Int
    let sunset: Int
    
    enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case name
        case coordinates = "coord"
        case country
        case population
        case timezone
        case sunrise
        case sunset
    }
}

struct Coordinates: Codable {
    let latitude: Double
    let longitude: Double
    
    enum CodingKeys: String, CodingKey {
        case latitude = "lat"
        case longitude = "lon"
    }
}
