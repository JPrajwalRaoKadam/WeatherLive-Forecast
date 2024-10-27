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
    private var favorites: [CityWeatherDetailsModel] = []
    let refreshControl = UIRefreshControl()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        CommonMethods.shared.setGradientBackground(view: self.view)
        
        setupTableView()
        setupNotifications()
        updateUI()
    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setupTableView() {
        if let cityWeatherList = favListTableView {
            cityWeatherList.register(cellType: FavouriteCityTableViewCell.self)
        }
        self.configureRefreshControl()
    }
    
    private func setupNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(favoritesUpdated),
                                               name: FavoritesManager.favoritesUpdatedNotification,
                                               object: nil)
    }
    
    @objc private func favoritesUpdated() {
        updateUI()
    }
    
    private func updateUI() {
        favorites = FavoritesManager.shared.getAllFavorites()
        totalFavouriteCities(cities: favorites.count)
        favListTableView.reloadData()
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
        let alert = UIAlertController(title: "Remove All Favorites",
                                      message: "Are you sure you want to remove all favorite cities?",
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Remove All", style: .destructive) { [weak self] _ in
            FavoritesManager.shared.removeAllFavorites()
            self?.updateUI()
        })
        
        present(alert, animated: true)
        
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
        return favorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FavouriteCityTableViewCell", for: indexPath) as? FavouriteCityTableViewCell else {
            return UITableViewCell()
        }
        
        let favorite = favorites[indexPath.row]
        cell.configureFavouriteListCell(data: favorite)
        cell.favButton.isSelected = true
        
        // Handle favorite button tap in cell
        cell.favButton.addTarget(self, action: #selector(favoriteCellButtonTapped(_:)), for: .touchUpInside)
        cell.favButton.tag = indexPath.row
        
        return cell
    }
    
    @objc private func favoriteCellButtonTapped(_ sender: ToggleButton) {
        let index = sender.tag
        let favorite = favorites[index]
        _ = FavoritesManager.shared.toggleFavorite(favorite)
    }
}

