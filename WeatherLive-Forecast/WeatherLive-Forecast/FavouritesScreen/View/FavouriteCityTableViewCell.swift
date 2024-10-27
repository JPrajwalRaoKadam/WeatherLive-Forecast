//
//  FavouriteCityTableViewCell.swift
//  WeatherLive-Forecast
//
//  Created by Prajwal rao Kadam J on 24/10/24.
//

import UIKit

class FavouriteCityTableViewCell: UITableViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var cityName: UILabel!
    
    @IBOutlet weak var cityWeather: UILabel!
    
    @IBOutlet weak var temperature: UILabel!
    
    @IBOutlet weak var favButton: ToggleButton!
    
    private var cityData: CityWeatherDetailsModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setUp()
    }
    
    private func setUp() {
        favButton.isSelected = false
        self.containerView.layer.cornerRadius = 10.0
        self.containerView.backgroundColor = .systemPurple
        
        // Adding shadow effect
        self.containerView.layer.shadowColor = UIColor.black.cgColor // Color of the shadow
        self.containerView.layer.shadowOpacity = 0.5 // Opacity of the shadow (0.0 to 1.0)
        self.containerView.layer.shadowOffset = CGSize(width: 0, height: 2) // The offset of the shadow (how far it is)
        self.containerView.layer.shadowRadius = 4.0 // How blurred the shadow is
        
        // Optional: Improve performance by rasterizing the shadow
        self.containerView.layer.shouldRasterize = true
        self.containerView.layer.rasterizationScale = UIScreen.main.scale
        
    }
    
    //MARK: - configure Recent List Cell
    func configureRecentListCell(data: CityWeatherDetailsModel) {
        self.cityData = data
        self.cityName.text = data.cityName
        self.temperature.text = data.temperature
        self.cityWeather.text = data.weatherDescription
    }
    
    //MARK: - configure Favourites List Cell
    func configureFavouriteListCell(data: CityWeatherDetailsModel) {
        self.cityData = data
        self.cityName.text = data.cityName
        self.temperature.text = data.temperature
        self.cityWeather.text = data.weatherDescription
        
        // Update favorite button state
        updateFavoriteButtonState()
    }
    
    private func updateFavoriteButtonState() {
        guard let data = cityData else { return }
        DispatchQueue.main.async {
            self.favButton.isSelected = FavoritesManager.shared.isFavorite(data)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cityData = nil
        favButton.isSelected = false
    }
}
