//
//  WeatherDetailCollectionViewCell.swift
//  WeatherLive-Forecast
//
//  Created by Prajwal rao Kadam J on 24/10/24.
//

import UIKit

class WeatherDetailCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var weatherDetailImageView: UIImageView!
    
    @IBOutlet weak var WeatherType: UILabel!
    
    @IBOutlet weak var weatherRange: UILabel!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(data: WeatherItem) {
        self.WeatherType.text = data.title
        self.weatherRange.text = "\(data.value) \(data.unit)"
        self.weatherDetailImageView.image = UIImage(named: data.imageName)
    }

}
