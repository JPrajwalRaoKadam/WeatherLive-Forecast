//
//  FavouritesManager.swift
//  WeatherLive-Forecast
//
//  Created by Prajwal rao Kadam J on 27/10/24.
//

import UIKit

class FavoritesManager {
    static let shared = FavoritesManager()
    private init() {}
    
    private var favorites: [CityWeatherDetailsModel] = []
    
    // Notification name for favorites updates
    static let favoritesUpdatedNotification = Notification.Name("FavoritesUpdatedNotification")
    private let queue = DispatchQueue(label: "com.weatherapp.favoritesManager", attributes: .concurrent)
    
    func toggleFavorite(_ city: CityWeatherDetailsModel) -> Bool {
        var result = false
        queue.sync(flags: .barrier) {
            if let index = favorites.firstIndex(where: { $0.cityName == city.cityName }) {
                favorites.remove(at: index)
                result = false
            } else {
                favorites.append(city)
                result = true
            }
        }
        
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: FavoritesManager.favoritesUpdatedNotification, object: nil)
        }
        return result
    }
    
    func isFavorite(_ city: CityWeatherDetailsModel) -> Bool {
        queue.sync {
            return favorites.contains(where: { $0.cityName == city.cityName })
        }
    }
    
    func getAllFavorites() -> [CityWeatherDetailsModel] {
        queue.sync {
            return favorites
        }
    }
    
    func removeAllFavorites() {
        queue.sync(flags: .barrier) {
            favorites.removeAll()
        }
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: FavoritesManager.favoritesUpdatedNotification, object: nil)
        }
    }
}
