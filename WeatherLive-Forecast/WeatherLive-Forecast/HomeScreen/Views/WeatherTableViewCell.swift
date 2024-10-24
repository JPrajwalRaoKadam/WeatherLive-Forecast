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
    
    @IBOutlet weak var celciusFahrenheitToggle: UISegmentedControl!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func celciusFahrenheitAction(_ sender: Any) {
        
    }
    
}
