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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        weatherForecastTableView.register(cellType: DaysWeatherTableViewCell.self)
        
        // Allow automatic row height based on content
        weatherForecastTableView.estimatedRowHeight = UITableView.automaticDimension
        weatherForecastTableView.rowHeight = UITableView.automaticDimension
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
        1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DaysWeatherTableViewCell", for: indexPath)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        setTableViewHeight()
//    }
}
