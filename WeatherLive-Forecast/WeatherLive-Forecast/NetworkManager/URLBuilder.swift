//
//  URLBuilder.swift
//  WeatherLive-Forecast
//
//  Created by Prajwal rao Kadam J on 25/10/24.
//

import Foundation

class URLBuilder {
    private let baseURL: String = "https://api.openweathermap.org/data/2.5/"
    private var endpoint: String?
    private var queryParams: [String: String] = [:]
    
    func setEndpoint(_ endpoint: String) -> URLBuilder {
        self.endpoint = endpoint
        return self
    }
    
    func addQueryParameter(key: String, value: String) -> URLBuilder {
        queryParams[key] = value
        return self
    }
    
    func build() -> URL? {
        guard let endpoint = endpoint else {
            print("Error: Endpoint is not set.")
            return nil
        }
        
        let urlString = baseURL + endpoint
        
        // Add query parameters
        if !queryParams.isEmpty {
            var components = URLComponents(string: urlString)
            components?.queryItems = queryParams.map { URLQueryItem(name: $0.key, value: $0.value) }
            return components?.url
        }
        
        return URL(string: urlString)
    }
}
