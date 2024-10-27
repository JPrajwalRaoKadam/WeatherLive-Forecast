//
//  LocationCityModel.swift
//  WeatherLive-Forecast
//
//  Created by Prajwal rao Kadam J on 23/10/24.
//

import Foundation

// MARK: - WeatherResponse
struct WeatherDataResponse: Codable {
    let coord: CoordData
    let weather: [WeatherData]
    let base: String
    let main: MainData
    let visibility: Int
    let wind: WindData
    let clouds: CloudsData
    let dt: Int
    let sys: SysData
    let timezone: Int
    let id: Int
    let name: String
    let cod: Int
}

// MARK: - Coord
struct CoordData: Codable {
    let lon: Double
    let lat: Double
}

// MARK: - Weather
struct WeatherData: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

// MARK: - Main
struct MainData: Codable {
    let temp: Double
    let feels_like: Double
    let temp_min: Double
    let temp_max: Double
    let pressure: Int
    let humidity: Int
    let sea_level: Int?
    let grnd_level: Int?
}

// MARK: - Wind
struct WindData: Codable {
    let speed: Double
    let deg: Int
}

// MARK: - Clouds
struct CloudsData: Codable {
    let all: Int
}

// MARK: - Sys
struct SysData: Codable {
    let type: Int
    let id: Int
    let country: String
    let sunrise: Int
    let sunset: Int
}
