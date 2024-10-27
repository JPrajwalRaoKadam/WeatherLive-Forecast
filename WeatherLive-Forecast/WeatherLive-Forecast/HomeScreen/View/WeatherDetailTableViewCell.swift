//
//  WeatherDetailTableViewCell.swift
//  WeatherLive-Forecast
//
//  Created by Prajwal rao Kadam J on 24/10/24.
//

import UIKit

class WeatherDetailTableViewCell: UITableViewCell {
    
    @IBOutlet weak var weatherDetailCollectioView: UICollectionView!
    
    private var cityDataWeatherDetails: CityDataWeatherDetailsModel?
    
    var weatherItems: [WeatherItem] = []
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        weatherDetailCollectioView.register(cellType: WeatherDetailCollectionViewCell.self)
        self.weatherDetailCollectioView.backgroundColor = .systemPurple.withAlphaComponent(0.2)
        setupCollectionViewShadow()
    }
    
    func configureCell(data: [WeatherItem]) {
        self.weatherItems = data
        self.weatherDetailCollectioView.reloadData()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // Call this in viewDidLoad or after the collection view is initialized
    func setupCollectionViewShadow() {
            // Create shadow layer for top shadow
            let topShadow = CALayer()
            topShadow.frame = CGRect(x: 0, y: 0, width: weatherDetailCollectioView.frame.width, height: 8)
            topShadow.shadowColor = UIColor.black.cgColor
            topShadow.shadowOffset = CGSize(width: 0, height: 2)
            topShadow.shadowOpacity = 0.2
            topShadow.shadowRadius = 4
            
            // Create shadow layer for bottom shadow
            let bottomShadow = CALayer()
            bottomShadow.frame = CGRect(x: 0,
                                       y: weatherDetailCollectioView.frame.height - 8,
                                       width: weatherDetailCollectioView.frame.width,
                                       height: 8)
            bottomShadow.shadowColor = UIColor.black.cgColor
            bottomShadow.shadowOffset = CGSize(width: 0, height: -2)
            bottomShadow.shadowOpacity = 0.2
            bottomShadow.shadowRadius = 4
            
            // Add shadow layers
            weatherDetailCollectioView.layer.addSublayer(topShadow)
            weatherDetailCollectioView.layer.addSublayer(bottomShadow)
            
            // Collection view styling
            weatherDetailCollectioView.layer.masksToBounds = false
            weatherDetailCollectioView.clipsToBounds = false
            
            // Optional: Add corner radius if needed
            weatherDetailCollectioView.layer.cornerRadius = 12
        }
        
        // Override layoutSubviews to update shadow frames when cell is resized
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Update shadow frames if needed
        if let topShadow = weatherDetailCollectioView.layer.sublayers?.first,
           let bottomShadow = weatherDetailCollectioView.layer.sublayers?.last {
            topShadow.frame = CGRect(x: 0, y: 0,
                                     width: weatherDetailCollectioView.frame.width, height: 8)
            bottomShadow.frame = CGRect(x: 0,
                                        y: weatherDetailCollectioView.frame.height - 8,
                                        width: weatherDetailCollectioView.frame.width, height: 8)
        }
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
