//
//  ApiKeyChainManager.swift
//  WeatherLive-Forecast
//
//  Created by Prajwal rao Kadam J on 25/10/24.
//

import Foundation
import Security

protocol SendRetreivedApiKey: AnyObject {
    func sendApiKey(key: String)
}

class APIKeyManager {
    private let apiKeyKey = "personal.com.WeatherLive-Forecast" // Replace with your app’s unique identifier
    
     var delegate: SendRetreivedApiKey?
    
    
     init() {
        initializeApiKey()
         retreiveApiKey()
    }
    
    
    private func initializeApiKey() {
        let apiKey = "8c6787bccce2b30fe6f6a6a2e42d6a9e"
        if self.storeAPIKey(apiKey) {
            print("API Key stored successfully.")
        } else {
            print("Failed to store API Key.")
        }
    }

    // Store API Key securely in Keychain
    private func storeAPIKey(_ apiKey: String) -> Bool {
        guard let apiKeyData = apiKey.data(using: .utf8) else { return false }
        
        // Create a query for saving the key
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: apiKeyKey,
            kSecValueData as String: apiKeyData
        ]
        
        // Delete any existing key with the same identifier to prevent duplicates
        SecItemDelete(query as CFDictionary)
        
        // Add the new key to the Keychain
        let status = SecItemAdd(query as CFDictionary, nil)
        
        return status == errSecSuccess
    }

    // Retrieve API Key securely from Keychain
    private func retrieveAPIKey() -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: apiKeyKey,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        
        guard status == errSecSuccess, let data = item as? Data,
              let apiKey = String(data: data, encoding: .utf8) else {
            print("Error retrieving API Key or API Key not found.")
            return nil
        }
        
        return apiKey
    }

    // Delete API Key from Keychain (optional)
    private func deleteAPIKey() -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: apiKeyKey
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        return status == errSecSuccess
    }
    
      func retreiveApiKey() -> String{
        if let retrievedKey = self.retrieveAPIKey() {
            print("Retrieved API Key: \(retrievedKey)")
           return retrievedKey
        } else {
            print("Failed to retrieve API Key.")
            return ""
        }
    }
}

