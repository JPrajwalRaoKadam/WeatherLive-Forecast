# WeatherLive-Forecast

A simple and intuitive iOS weather application that displays current weather conditions based on user location, with support for favorites and search history.

## Features
- Real-time weather information
- Location-based weather updates
- Search any location for weather information
- Favorites management:
  - Add locations to favorites
  - View favorite locations' weather
- Recent searches:
  - Automatically tracks search history
  - Persists between app launches using Core Data
  - Available until app termination
- Clean and user-friendly interface

## Requirements
- iOS 13.0+
- Xcode 13.0+
- Swift 5.0+
- Location permissions enabled on device

## Installation
1. Clone the repository
```bash
git clone [https://github.com/JPrajwalRaoKadam/WeatherLive-Forecast.git]
```
2. Open the project in Xcode
```bash
cd [project-directory]
open WeatherLive-Forecast.xcodeproj
```
3. Build and run the application using Xcode's simulator or a physical device

## Architecture
- Home Screen: MVVM (Model-View-ViewModel) architecture for better separation of concerns and testability
- Other Screens: MVC (Model-View-Controller) architecture
- Core Data implementation for persistent storage of recent searches
- No external dependencies required

## Data Persistence
- Recent searches are stored using Core Data
- Data persists between app launches
- Favorites are stored for quick access

## Permissions
The application requires location permissions to function properly:
- When first launching the app, you will be prompted to allow location access
- Location services must be enabled to fetch weather data for your current location

## Design Choices
1. Architecture:
   - MVVM for home screen to maintain clean separation of business logic and UI
   - MVC for simpler screens where complex data binding isn't necessary
   - Core Data for efficient local storage of search history

2. User Experience:
   - Minimal setup required - just clone and run
   - Straightforward permission handling
   - Easy access to favorite locations
   - Quick reference to recent searches
   - Search functionality for any location
   - Intuitive weather information display

## Support
For any issues or questions, please open an issue in the repository.
