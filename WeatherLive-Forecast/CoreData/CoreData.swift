//
//  CoreData.swift
//  WeatherLive-Forecast
//
//  Created by Prajwal rao Kadam J on 25/10/24.
//
import UIKit
import CoreData


class CoreDataManager {
    static let shared = CoreDataManager()
    
    private init() {}
    
    var persistentContainer: NSPersistentContainer {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("AppDelegate not found")
        }
        return appDelegate.persistentContainer
    }
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func saveContext() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        appDelegate.saveContext()
    }
    
    // MARK: - Recent Weather Methods
    func saveRecentWeather(details: CityWeatherDetailsModel) {
        let recentWeather = RecentWeather(context: context)
        recentWeather.cityName = details.cityName
        recentWeather.temperature = details.temperature
        recentWeather.weatherDescription = details.weatherDescription
        recentWeather.weatherImage = details.weatherImage
        recentWeather.timestamp = Date()
        
        saveContext()
    }
    
    func saveRecentWeatherList(details: [CityWeatherDetailsModel]) {
        // Clear existing data
        clearRecentWeather()
        
        // Save new data
        for detail in details {
            saveRecentWeather(details: detail)
        }
        
        // Force save
        do {
            try context.save()
        } catch {
            print("Error saving context: \(error)")
        }
    }
    
    func fetchRecentWeather() -> [CityWeatherDetailsModel] {
        let fetchRequest: NSFetchRequest<RecentWeather> = RecentWeather.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]
        
        do {
            let results = try context.fetch(fetchRequest)
            return results.map { recentWeather in
                CityWeatherDetailsModel(
                    cityName: recentWeather.cityName ?? "",
                    temperature: recentWeather.temperature ?? "",
                    weatherDescription: recentWeather.weatherDescription ?? "",
                    weatherImage: recentWeather.weatherImage ?? ""
                )
            }
        } catch {
            print("Error fetching recent weather: \(error)")
            return []
        }
    }
    
    func clearRecentWeather() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = RecentWeather.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(deleteRequest)
            try context.save() // Add explicit save after deletion
        } catch {
            print("Error clearing recent weather: \(error)")
        }
    }
}
