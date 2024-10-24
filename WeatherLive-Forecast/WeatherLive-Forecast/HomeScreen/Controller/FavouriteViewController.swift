//
//  FavouriteViewController.swift
//  WeatherLive-Forecast
//
//  Created by Prajwal rao Kadam J on 24/10/24.
//

import UIKit

class FavouriteViewController: UIViewController {
 
    @IBOutlet weak var favListTableView: UITableView!
    
    @IBOutlet weak var totalNumberOfFavourites: UILabel!
    
    @IBOutlet weak var removeAllContentButton: UIButton!

    @IBOutlet weak var emptyMessege: UILabel!
    let refreshControl = UIRefreshControl()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
       // self.view.backgroundColor = .clear
        CommonMethods.shared.setGradientBackground(view: self.view)
        if let cityWeatherList = favListTableView {
            cityWeatherList.register(cellType: FavouriteCityTableViewCell.self)
        }
        totalFavouriteCities(cities: 5)
        self.configureRefreshControl()
    }
    
    func totalFavouriteCities(cities: Int) {
        switch cities {
        case 0:
            handleUI(hide: true)
        case 1:
            handleUI(hide: false)
            self.totalNumberOfFavourites.text = "\(cities) City added as favourite"
        default:
            handleUI(hide: false)
            self.totalNumberOfFavourites.text = "\(cities) Cities added as favourite"
        }
    }
    
    func handleUI(hide: Bool) {
        self.totalNumberOfFavourites.isHidden = hide
        self.removeAllContentButton.isHidden = hide
        self.favListTableView.isHidden = hide
        self.emptyMessege.isHidden = !hide
    }
    
    
    @IBAction func backButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func removeAllFavourites(_ sender: Any) {


    }
    
    func configureRefreshControl() {
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        favListTableView.refreshControl = refreshControl
    }
    
    @objc func refreshData() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            // self.data = ["New Item \(self.currentPage + 1)"]
            self.favListTableView.reloadData()
            self.refreshControl.endRefreshing()
        }
    }

}

extension FavouriteViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
    
extension FavouriteViewController: UITableViewDataSource {
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

