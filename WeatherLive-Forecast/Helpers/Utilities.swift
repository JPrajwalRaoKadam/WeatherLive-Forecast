//
//  Utilities.swift
//  WeatherLive-Forecast
//
//  Created by Prajwal rao Kadam J on 24/10/24.
//

import UIKit

class CommonMethods {
    
    static let shared = CommonMethods()
    
    private init() {}
    
    
    func setGradientBackground(view: UIView) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [
            UIColor.systemPurple.cgColor,
            UIColor.systemPurple.withAlphaComponent(0.5).cgColor
        ]
        gradientLayer.locations = [0.0, 1.0]
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func kelvinToCelsius(kelvin: Double) -> String {
        let celsius = kelvin - 273.15
        return String(format: "%.2f", celsius) // Round to two decimal places
    }

}



enum WeatherType: String {
    
    case drizzle = "Drizzle"
    case rain = "Rain"
    case snow = "Snow"
    case atmosphere = "Atmosphere"
    case clear = "Clear"
    case clouds = "Clouds"
    
    // Thunderstorm Conditions
    case thunderstormWithLightRain = "Thunderstorm with light rain"
    case thunderstormWithRain = "Thunderstorm with rain"
    case heavyThunderstorm = "Heavy thunderstorm"
    case lightThunderstorm = "Light thunderstorm"
    case thunderstormWithDrizzle = "Thunderstorm with drizzle"
    
    // Drizzle Conditions
    case lightIntensityDrizzle = "Light intensity drizzle"
    case moderateDrizzle = "Moderate drizzle"
    case heavyIntensityDrizzle = "Heavy intensity drizzle"
    case showerRainAndDrizzle = "Shower rain and drizzle"
    
    // Rain Conditions
    case lightRain = "Light Rain"
    case moderateRain = "Moderate Rain"
    case heavyRain = "Heavy Rain"
    case freezingRain = "Freezing Rain"
    case showerRain = "Shower Rain"
    
    // Snow Conditions
    case lightSnow = "Light Snow"
    case heavySnow = "Heavy Snow"
    case sleet = "Sleet"
    
    // Atmosphere Conditions
    case mist = "Mist"
    case smoke = "Smoke"
    case haze = "Haze"
    case fog = "Fog"
    case tornado = "Tornado"
    
    // Clear Conditions
    case clearSky = "Clear sky"
    
    // Cloud Conditions
    case fewClouds = "Few Clouds"
    case scatteredClouds = "Scattered Clouds"
    case brokenClouds = "Broken Clouds"
    case overcastClouds = "Overcast Clouds"
    
    func imageName() -> String {
        switch self {
        case .clear, .clearSky:
            return "sun.max.fill" // or use "clear" if you have a custom image
        case .fewClouds, .clouds:
            return "cloud.sun.fill"
        case .scatteredClouds:
            return "cloud.fill"
        case .brokenClouds:
            return "cloud.fill"
        case .overcastClouds:
            return "cloud"
        case .drizzle, .lightIntensityDrizzle, .moderateDrizzle, .heavyIntensityDrizzle, .showerRainAndDrizzle:
            return "cloud.drizzle.fill"
        case .lightRain, .moderateRain, .heavyRain, .showerRain, .rain:
            return "cloud.rain.fill"
        case .freezingRain:
            return "cloud.snow.fill" // Freezing rain may be represented with snow image
        case .lightSnow, .heavySnow, .sleet, .snow:
            return "snow"
        case .mist, .smoke, .haze, .fog, .atmosphere:
            return "cloud.fog.fill"
        case .tornado:
            return "tornado"
        case .thunderstormWithLightRain, .thunderstormWithRain, .heavyThunderstorm, .lightThunderstorm, .thunderstormWithDrizzle:
            return "cloud.bolt.rain.fill"
        }
    }
    
    static func imageName(for weather: String) -> String? {
        // Convert input to title case (first letter of each word capitalized)
        let words = weather.components(separatedBy: " ")
        let titleCased = words.map { $0.prefix(1).uppercased() + $0.dropFirst().lowercased() }
        let formattedWeather = titleCased.joined(separator: " ")
        
        print("Trying to match: \(formattedWeather)") // Debug print
        
        if let weatherType = WeatherType(rawValue: formattedWeather) {
            return weatherType.imageName()
        }
        return nil
    }
}

