//
//  HomeViewController.swift
//  WeatherLive-Forecast
//
//  Created by Prajwal rao Kadam J on 23/10/24.
//

import UIKit
import CoreLocation

class HomeViewController: UIViewController {
    
    @IBOutlet weak var homeTableView: UITableView!
    
    var Swipedata = ["Item 1", "Item 2", "Item 3"]
    
    // Refresh control
    let refreshControl = UIRefreshControl()
    var currentTableview: UITableView = UITableView()
    private var refreshControls: [UIRefreshControl] = []
    private var cityWeatherDetails: CityWeatherDetailsModel?
    private var weatherItems: [WeatherItem]?
    var recentWeatherDetailsList: [CityWeatherDetailsModel] = []
    var favoriteCities: [CityWeatherDetailsModel] = []
    
    private lazy var pageControl: UIPageControl = {
        let control = UIPageControl()
        control.numberOfPages = Swipedata.count
        control.currentPage = 0
        control.pageIndicatorTintColor = .gray
        control.currentPageIndicatorTintColor = .white
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.isPagingEnabled = true
        scroll.showsHorizontalScrollIndicator = false
        scroll.delegate = self
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()
    
    
    let locationManager = LocationManager()
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    var cityName: String = ""
    var hamburgerMenu: HamburgerMenu!
    var currentPage: Int = 0
    private var pageTableViews: [UITableView] = []
    var viewModel: HomeViewModel?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        self.homeTableView.isHidden = true
        setupFavoritesNotification()
        locationManager.requestLocation()
        //   homeTableView.backgroundColor = .purple
        homeTableView.register(cellType: WeatherTableViewCell.self)
        homeTableView.register(cellType: WeatherDetailTableViewCell.self)
        homeTableView.register(cellType: RecentWeatherTableViewCell.self)
        
        
        hamburgerMenu = HamburgerMenu()
        view.addSubview(hamburgerMenu)
        self.hamburgerMenu.delegate = self
        
        CommonMethods.shared.setGradientBackground(view: self.view)
        self.currentTableview = homeTableView
        
        self.viewModel = HomeViewModel(self)
        
        getCurrentLatLon()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    // Update viewDidLoad to call updateContentSize when view layout is complete
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateContentSize()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    
    func setupFavoritesNotification() {
            NotificationCenter.default.addObserver(self,
                                                 selector: #selector(handleFavoritesUpdate),
                                                 name: FavoritesManager.favoritesUpdatedNotification,
                                                 object: nil)
        }
        
        @objc private func handleFavoritesUpdate() {
            // Refresh all page table views
            pageTableViews.forEach { $0.reloadData() }
        }
    
    
    private func setupUI() {
        scrollView.backgroundColor = .clear
        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.8)
        ])
        
        let contentWidth = view.bounds.width * CGFloat(Swipedata.count)
        scrollView.contentSize = CGSize(width: contentWidth, height: scrollView.bounds.height)
        
        // Create table views and refresh controls for each page
        for i in 0..<Swipedata.count {
            let tableView = UITableView(frame: .zero, style: .plain)
            tableView.delegate = self
            tableView.dataSource = self
            tableView.translatesAutoresizingMaskIntoConstraints = false
            tableView.backgroundColor = .clear
            tableView.separatorStyle = .none
            
            // Register cells
            tableView.register(cellType: WeatherTableViewCell.self)
            tableView.register(cellType: WeatherDetailTableViewCell.self)
            tableView.register(cellType: RecentWeatherTableViewCell.self)
            
            // Create and configure refresh control for this table view
            let refreshControl = UIRefreshControl()
            refreshControl.tag = i  // Tag the refresh control with its page index
            refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
            tableView.refreshControl = refreshControl
            refreshControls.append(refreshControl)
            
            scrollView.addSubview(tableView)
            pageTableViews.append(tableView)
            
            NSLayoutConstraint.activate([
                tableView.topAnchor.constraint(equalTo: scrollView.topAnchor),
                tableView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: CGFloat(i) * view.bounds.width),
                tableView.widthAnchor.constraint(equalToConstant: view.bounds.width),
                tableView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
            ])
        }
        
        pageControl.backgroundColor = .clear
        view.addSubview(pageControl)
        NSLayoutConstraint.activate([
            pageControl.topAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 10),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageControl.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    @objc func refreshData(_ sender: UIRefreshControl) {
        let pageIndex = sender.tag
        viewModel?.getHomeScreenWeatherData(latitude: latitude, longitude: longitude)
        
        // Simulate network delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            // Update data for the specific page
            // self.getCurrentWeatherData()  // Fetch new weather data
            
            // End refreshing
            sender.endRefreshing()
            // Reload the specific table view
            self.pageTableViews[pageIndex].reloadData()
        }
    }
    
    // Update scrollViewDidEndDecelerating
    
    
    // Update handleSwipe
    @objc private func handleSwipe(_ gesture: UISwipeGestureRecognizer) {
        let direction: CGFloat = gesture.direction == .left ? 1 : -1
        let nextPage = max(0, min(currentPage + Int(direction), Swipedata.count - 1))
        
        if nextPage != currentPage {
            currentPage = nextPage
            pageControl.currentPage = currentPage
            
            let point = CGPoint(x: scrollView.bounds.width * CGFloat(currentPage), y: 0)
            scrollView.setContentOffset(point, animated: true)
            
            // Refresh the next page's table view
            let tableView = pageTableViews[nextPage]
            tableView.reloadData()
            self.currentTableview = tableView // Update the currentTableview
            // self.configureRefreshControl()
        }
    }
    
    
    
    private func updateContentSize() {
        let contentWidth = view.bounds.width * CGFloat(Swipedata.count)
        scrollView.contentSize = CGSize(width: contentWidth, height: scrollView.bounds.height)
    }
    
    @IBAction func hamburgerMenuTapped(_ sender: Any) {
        hamburgerMenu.toggleMenu(on: self)
    }
    
    @IBAction func searchButtonAction(_ sender: Any) {
        let citySearchVC = CitySearchViewController()
        citySearchVC.delegate = self
        navigationController?.pushViewController(citySearchVC, animated: true)
    }
    
    func swipeAnimation() {
        let originalPosition = self.homeTableView.frame.origin.x
        
        for i in 0..<5 {
            // Animate each swipe with a delay
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.5) {
                UIView.animate(withDuration: 0.5, animations: {
                    self.homeTableView.frame.origin.x = originalPosition + 300 // Swipe right
                }) { _ in
                    UIView.animate(withDuration: 0.5, animations: {
                        self.homeTableView.frame.origin.x = originalPosition // Go back to original position
                    })
                }
            }
        }
    }
    
    
    func getCurrentLatLon() {
        locationManager.onLocationUpdate = { coordinate in
            // print("Latitude: \(coordinate.latitude), Longitude: \(coordinate.longitude)")
            self.latitude = coordinate.latitude
            self.longitude = coordinate.longitude
            
            self.viewModel?.getHomeScreenWeatherData(latitude: self.latitude, longitude: self.longitude)
        }
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherTableViewCell", for: indexPath) as?  WeatherTableViewCell {
                guard let data = self.cityWeatherDetails ?? nil else { return WeatherTableViewCell() }
                cell.configureCell(data: data)
                return cell
            }
        case 1:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherDetailTableViewCell", for: indexPath) as?  WeatherDetailTableViewCell {
                cell.configureCell(data: self.weatherItems ?? [])
                return cell
            }
        default :
            if let cell = tableView.dequeueReusableCell(withIdentifier: "RecentWeatherTableViewCell", for: indexPath) as? RecentWeatherTableViewCell {
                //  cell.setTableViewHeight()
                return cell
            }
        }
        return UITableViewCell()
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableView.estimatedRowHeight = 250
        return UITableView.automaticDimension
    }
}


extension HomeViewController: MenuItemsTapped {
    
    func menuItemsAction(item: MenuItems) {
        switch item {
        case .home:
            print("Home")
        case .favourites:
            self.pushViewControllerNew(withIdentifier: "FavouriteViewController") { (favouriteCityVC: FavouriteViewController) in
                //TODO: - Pass data to fav vc
            }
        case .recents:
            let recentList = CoreDataManager.shared.fetchRecentWeather()
            self.pushViewControllerNew(withIdentifier: "RecentSearchViewController") { (detailVC: RecentSearchViewController) in
                detailVC.configureRecentList(recentList: recentList)
            }
        }
    }
    
    private func getRecentsViewController() -> RecentSearchViewController? {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "RecentSearchViewController") as? RecentSearchViewController
    }
}


// Add UIScrollViewDelegate extension
extension HomeViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page = Int(scrollView.contentOffset.x / scrollView.bounds.width)
        currentPage = page
        pageControl.currentPage = page
        
        // Refresh the current page's table view
        self.currentTableview = pageTableViews[page]
        pageTableViews[page].reloadData()
    }
}


extension HomeViewController: HomeScreenDataProtocol {
    func showLoader() {
        LoaderManager.shared.showLoader(on: self.view)
    }
    
    func hideLoader() {
        LoaderManager.shared.hideLoader()
    }
    
    func sendHomeScreenData(data: CityWeatherDetailsModel, weatherItems: [WeatherItem], isFromSearch: Bool) {
        LoaderManager.shared.hideLoader()
        DispatchQueue.main.async {
            self.cityWeatherDetails = data
            self.weatherItems = weatherItems
            if isFromSearch {
                self.recentWeatherDetailsList.append(data)
                self.saveRecentWeatherToCoreData(data: self.recentWeatherDetailsList)
            }
            self.pageTableViews.forEach { $0.reloadData() }
        }
    }
    
    func handleError(_ error: Error) {
        DispatchQueue.main.async {
            // Hide loader in case of error
            LoaderManager.shared.hideLoader()
            
            // Show error alert
            let alert = UIAlertController(title: "Error",
                                          message: error.localizedDescription,
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
        }
    }
}


extension HomeViewController: SendSearchData {
    
    func sendSearchData(cityName: String) {
        viewModel?.getWeatherData(cityName: cityName)
        self.pageTableViews.forEach { $0.reloadData() }
    }
}

extension HomeViewController {
    func saveRecentWeatherToCoreData(data: [CityWeatherDetailsModel]) {
        DispatchQueue.main.async {
            CoreDataManager.shared.saveRecentWeatherList(details: data)
        }
    }
}
