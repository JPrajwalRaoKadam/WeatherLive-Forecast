//
//  RecentSearchViewController.swift
//  WeatherLive-Forecast
//
//  Created by Prajwal rao Kadam J on 24/10/24.
//

import UIKit

class RecentSearchViewController: UIViewController {
    
    @IBOutlet weak var recentSearchedTableView: UITableView!
    
    @IBOutlet weak var emptyMessege: UILabel!
    
    var recentWeatherDetailsList: [CityWeatherDetailsModel] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // self.navigationController?.isNavigationBarHidden = true
        recentSearchedTableView.register(cellType: FavouriteCityTableViewCell.self)
        CommonMethods.shared.setGradientBackground(view: self.view)
        
       // loadRecentWeatherFromCoreData()
            
            // Debug print to check data
        print("Loaded weather count: \(recentWeatherDetailsList.count)")
    }
    
    func totalRecentSearchedCities(cities: Int) {
        switch cities {
        case 0:
            handleUI(hide: true)
        case 1:
            handleUI(hide: false)
        default:
            handleUI(hide: false)
        }
    }
    
    func handleUI(hide: Bool) {
        self.recentSearchedTableView.isHidden = hide
        self.emptyMessege.isHidden = !hide
    }
    
    func configureRecentList(recentList: [CityWeatherDetailsModel]) {
        print("Configuring with \(recentList.count) items")
        totalRecentSearchedCities(cities: recentList.count)
        self.recentWeatherDetailsList = recentList
        self.recentSearchedTableView.reloadData()
        
        // Save to Core Data
        //saveRecentWeatherToCoreData()
    }
    
    @IBAction func backButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}

extension RecentSearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return recentWeatherDetailsList.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "FavouriteCityTableViewCell", for: indexPath) as? FavouriteCityTableViewCell {
            let data = self.recentWeatherDetailsList[indexPath.row]
            cell.configureRecentListCell(data: data)
            cell.favButton.isHidden = true
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}
