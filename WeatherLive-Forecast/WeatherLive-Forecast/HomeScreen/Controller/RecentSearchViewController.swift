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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        
        CommonMethods.shared.setGradientBackground(view: self.view)
        if let cityWeatherList = recentSearchedTableView {
            cityWeatherList.register(cellType: FavouriteCityTableViewCell.self)
        }
        
        totalRecentSearchedCities(cities: 3)
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
    
    @IBAction func backButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}

extension RecentSearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 2
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavouriteCityTableViewCell", for: indexPath)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}


