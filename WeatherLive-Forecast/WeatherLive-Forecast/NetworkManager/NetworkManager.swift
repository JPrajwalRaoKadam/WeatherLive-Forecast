//
//  NetworkManager.swift
//  WeatherLive-Forecast
//
//  Created by Prajwal rao Kadam J on 23/10/24.
//

import Foundation

class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() {}
    
    // Generic method to fetch and decode any type conforming to Decodable
    func fetchData<T: Decodable>(from urlString: String, model: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = URL(string: urlString) else {
            print("Invalid URL.")
            return
        }
        
        print(url)
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            // Check for error
            if let error = error {
                completion(.failure(error))
                return
            }
            
            // Check for valid response
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                print("Invalid response.")
                return
            }
            
            // Ensure there's data
            guard let data = data else {
                print("No data received.")
                return
            }
            
            do {
                // Decode the JSON data into the specified model type
                let decodedData = try JSONDecoder().decode(model, from: data)
                completion(.success(decodedData))
            } catch let decodeError {
                completion(.failure(decodeError))
            }
        }
        
        task.resume() // Start the network request
    }
}
