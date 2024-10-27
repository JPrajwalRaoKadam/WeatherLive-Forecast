//
//  RecentWeatherTableViewCell.swift
//  WeatherLive-Forecast
//
//  Created by Prajwal rao Kadam J on 24/10/24.
//

import UIKit

class RecentWeatherTableViewCell: UITableViewCell {
    
    @IBOutlet weak var tableViewHeightCOnstraint: NSLayoutConstraint!
    
    @IBOutlet weak var weatherForecastTableView: UITableView!
    
    var dayWeatherItems: [DailyWeatherData] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        weatherForecastTableView.register(cellType: DaysWeatherTableViewCell.self)
        
        // Allow automatic row height based on content
        weatherForecastTableView.estimatedRowHeight = UITableView.automaticDimension
        weatherForecastTableView.rowHeight = UITableView.automaticDimension
    }
    
    func configureCell(data: [DailyWeatherData]) {
        self.dayWeatherItems = data
        self.weatherForecastTableView.reloadData()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setTableViewHeight() {
        self.tableViewHeightCOnstraint.constant = self.weatherForecastTableView.contentSize.height
        self.weatherForecastTableView.reloadData()
        self.weatherForecastTableView.layoutIfNeeded()
    }
}

extension RecentWeatherTableViewCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dayWeatherItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let weatherDetailCell = tableView.dequeueReusableCell(withIdentifier: "DaysWeatherTableViewCell", for: indexPath) as? DaysWeatherTableViewCell {
            let data = self.dayWeatherItems[indexPath.row]
            weatherDetailCell.configureCell(data: data)
            return weatherDetailCell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
