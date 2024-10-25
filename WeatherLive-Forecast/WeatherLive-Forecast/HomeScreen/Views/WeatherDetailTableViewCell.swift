//
//  WeatherDetailTableViewCell.swift
//  WeatherLive-Forecast
//
//  Created by Prajwal rao Kadam J on 24/10/24.
//

import UIKit

//enum CityDataWeatherDetails {
//    case TempMinMax
//    case Humidity
//    case Pressure
//    case Description
//}

class WeatherDetailTableViewCell: UITableViewCell {
    
    @IBOutlet weak var weatherDetailCollectioView: UICollectionView!
    
    private var cityDataWeatherDetails: CityDataWeatherDetailsModel?
    
    var weatherItems: [WeatherItem] = []
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        weatherDetailCollectioView.register(cellType: WeatherDetailCollectionViewCell.self)
        
    }
    
    func configureCell(data: [WeatherItem]) {
        self.weatherItems = data
        self.weatherDetailCollectioView.reloadData()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension WeatherDetailTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        weatherItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let weatherDetailCell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeatherDetailCollectionViewCell", for: indexPath) as? WeatherDetailCollectionViewCell {
            let data = self.weatherItems[indexPath.row]
            weatherDetailCell.configureCell(data: data)
            return weatherDetailCell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let data = weatherItems[indexPath.row]
        let padding: CGFloat = 25 * 2 // 25 points on each side (left and right)
        
        // Create a temporary label to calculate exact size needed
        let tempLabel = UILabel()
        tempLabel.font = UIFont.systemFont(ofSize: 16)
        tempLabel.text = data.title
        let titleWidth = tempLabel.intrinsicContentSize.width
        
        tempLabel.font = UIFont.systemFont(ofSize: 14)
        tempLabel.text = "\(data.value) \(data.unit)"
        let valueUnitWidth = tempLabel.intrinsicContentSize.width
        
        // Get the maximum width needed
        let contentWidth = max(titleWidth, valueUnitWidth) + 45
        
        // Add padding to both sides
        let finalWidth = contentWidth + padding
        
        return CGSize(width: finalWidth, height: 95)
    }
    
}
