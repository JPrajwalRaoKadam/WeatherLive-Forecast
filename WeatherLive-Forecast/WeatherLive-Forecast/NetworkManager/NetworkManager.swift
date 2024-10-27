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
    
    // Custom error enum to handle different cases
    enum NetworkError: Error {
        case cityNotFound
        case serverError
        case invalidResponse
        case unknown(Int)
        
        var message: String {
            switch self {
            case .cityNotFound:
                return "City not found. Please check the city name and try again."
            case .serverError:
                return "Server error occurred. Please try again later."
            case .invalidResponse:
                return "Invalid response from server."
            case .unknown(let statusCode):
                return "Unknown error occurred (Status Code: \(statusCode))"
            }
        }
    }
    
    func fetchData<T: Decodable>(from url: URL, model: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        
        print(url)
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            // Check for error
            if let error = error {
                completion(.failure(error))
                return
            }
            
            // Check for valid response
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(NetworkError.invalidResponse))
                return
            }
            
            // Handle different status codes
            switch httpResponse.statusCode {
            case 200...299:
                // Success case, continue with data processing
                guard let data = data else {
                    print("No data received.")
                    return
                }
                
                do {
                    let decodedData = try JSONDecoder().decode(model, from: data)
                    completion(.success(decodedData))
                } catch let decodeError {
                    completion(.failure(decodeError))
                }
                
            case 404:
                completion(.failure(NetworkError.cityNotFound))
            case 500...599:
                completion(.failure(NetworkError.serverError))
            default:
                completion(.failure(NetworkError.unknown(httpResponse.statusCode)))
            }
        }
        
        task.resume()
    }
}
