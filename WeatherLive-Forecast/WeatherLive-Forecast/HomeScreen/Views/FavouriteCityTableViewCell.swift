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
    
    @IBOutlet weak var cityTime: UILabel!
    
    @IBOutlet weak var cityWeather: UILabel!
    
    @IBOutlet weak var temperature: UILabel!
    
    @IBOutlet weak var favButton: ToggleButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setUp()
    }
    
    private func setUp() {
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

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
