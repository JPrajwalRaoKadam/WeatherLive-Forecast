//
//  DaysWeatherTableViewCell.swift
//  WeatherLive-Forecast
//
//  Created by Prajwal rao Kadam J on 24/10/24.
//

import UIKit

class DaysWeatherTableViewCell: UITableViewCell {

    
    @IBOutlet weak var day: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var temperatureValue: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(data: DailyWeatherData) {
        self.day.text = data.date
        self.temperatureValue.text = CommonMethods.shared.kelvinToCelsius(kelvin: data.temperature)
        let weatherImage = getWeatherImage(weatherCondition:data.weatherImage)
        self.weatherImage.image = UIImage(systemName: weatherImage)
    }
    
    func getWeatherImage(weatherCondition: String) -> String {
        if let imageName = WeatherType.imageName(for: weatherCondition) {
            return imageName
        } else {
            print("Weather type not found for condition: \(weatherCondition)")
            return "questionmark.circle" // fallback system icon
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
