//
//  TableViewCell.swift
//  WeatherLive-Forecast
//
//  Created by Prajwal rao Kadam J on 24/10/24.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var cityName: UILabel!
    
    @IBOutlet weak var favButton: ToggleButton!
    
    @IBOutlet weak var weatherImage: UIImageView!
    
    @IBOutlet weak var weatherDescrition: UILabel!
    
    @IBOutlet weak var tempratureLabel: UILabel!
    
    private var cityData: CityWeatherDetailsModel?
       
       override func prepareForReuse() {
           super.prepareForReuse()
           cityData = nil
           favButton.isSelected = false
       }
       
       func configureCell(data: CityWeatherDetailsModel) {
           self.cityData = data
           self.cityName.text = data.cityName
           self.tempratureLabel.text = data.temperature
           self.weatherDescrition.text = data.weatherDescription
           self.weatherImage.image = UIImage(systemName: data.weatherImage)
           
           // Update favorite button state
           updateFavoriteButtonState()
       }
       
       private func updateFavoriteButtonState() {
           guard let data = cityData else { return }
           // Ensure UI updates happen on main thread
           DispatchQueue.main.async {
               self.favButton.isSelected = FavoritesManager.shared.isFavorite(data)
           }
       }
    
    @IBAction func toggleButtonAction(_ sender: ToggleButton) {
        guard let data = cityData else { return }
        favButton.isSelected = FavoritesManager.shared.toggleFavorite(data)
    }
    
}
