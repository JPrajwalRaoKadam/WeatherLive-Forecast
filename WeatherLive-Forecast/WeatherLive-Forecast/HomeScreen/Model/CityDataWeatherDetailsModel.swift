//
//  CityDataWeatherDetailsModel.swift
//  WeatherLive-Forecast
//
//  Created by Prajwal rao Kadam J on 25/10/24.
//

import Foundation

struct CityDataWeatherDetailsModel {
    let temp_min: Double
    let temp_max: Double
    let pressure: Int
    let humidity: Int
    var weatherDescription: String
}

struct WeatherItem {
    let title: String
    let value: String
    let unit: String
    let imageName: String
}


