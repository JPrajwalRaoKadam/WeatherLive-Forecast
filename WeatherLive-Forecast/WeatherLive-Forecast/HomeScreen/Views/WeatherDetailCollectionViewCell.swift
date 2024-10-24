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

}
