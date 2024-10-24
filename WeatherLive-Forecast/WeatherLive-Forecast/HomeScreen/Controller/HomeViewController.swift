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
    
    
    var data = ["Item 1", "Item 2", "Item 3", "Item 4", "Item 5"]
    
    // Refresh control
    let refreshControl = UIRefreshControl()
    var currentTableview: UITableView = UITableView()
    private var refreshControls: [UIRefreshControl] = []
    
    private lazy var pageControl: UIPageControl = {
        let control = UIPageControl()
        control.numberOfPages = data.count
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        self.homeTableView.isHidden = true
        locationManager.requestLocation()
        getCurrentLatLon()
        //   homeTableView.backgroundColor = .purple
        homeTableView.register(cellType: WeatherTableViewCell.self)
        homeTableView.register(cellType: WeatherDetailTableViewCell.self)
        homeTableView.register(cellType: RecentWeatherTableViewCell.self)
        
        
        hamburgerMenu = HamburgerMenu()
        view.addSubview(hamburgerMenu)
        self.hamburgerMenu.delegate = self
        
        CommonMethods.shared.setGradientBackground(view: self.view)
        self.currentTableview = homeTableView
        //  configureRefreshControl()
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
        
        let contentWidth = view.bounds.width * CGFloat(data.count)
        scrollView.contentSize = CGSize(width: contentWidth, height: scrollView.bounds.height)
        
        // Create table views and refresh controls for each page
        for i in 0..<data.count {
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
        
        // Simulate network delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            // Update data for the specific page
            self.getCurrentWeatherData()  // Fetch new weather data
            
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
        let nextPage = max(0, min(currentPage + Int(direction), data.count - 1))
        
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
    
    // Update viewDidLoad to call updateContentSize when view layout is complete
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateContentSize()
    }
    
    private func updateContentSize() {
        let contentWidth = view.bounds.width * CGFloat(data.count)
        scrollView.contentSize = CGSize(width: contentWidth, height: scrollView.bounds.height)
    }
    
    //    func configureRefreshControl() {
    //        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
    //        currentTableview.refreshControl = refreshControl
    //    }
    //
    //    @objc func refreshData() {
    //        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
    //            self.data = ["New Item \(self.currentPage + 1)"]
    //            self.currentTableview.reloadData()
    //            self.refreshControl.endRefreshing()
    //        }
    //    }
    
    //    @objc func refreshData() {
    //        // Reload data or fetch new data here
    //        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
    //            self.data = ["New Item 1", "New Item 2", "New Item 3", "New Item 4", "New Item 5"]
    //            self.homeTableView.reloadData()
    //            self.refreshControl.endRefreshing()
    //        }
    //    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    
    @IBAction func hamburgerMenuTapped(_ sender: Any) {
        hamburgerMenu.toggleMenu(on: self)
    }
    
    @IBAction func searchButtonAction(_ sender: Any) {
        
        let citySearchVC = CitySearchViewController()
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
        }
    }
    
    func getSearchCityName() {
        // Assign searched city name
    }
    
    func getWeatherData() {
        
        print("-----------------Search API -------------------------------------------------")
        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(self.cityName)&appid=8c6787bccce2b30fe6f6a6a2e42d6a9e"
        
        NetworkManager.shared.fetchData(from: urlString, model: WeatherResponse.self) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let weatherResponse):
                    print("Weather data: \(weatherResponse)")
                    print("City: \(weatherResponse.name)")
                    print("Temperature: \(weatherResponse.main.temp)")
                case .failure(let error):
                    print("Error fetching weather data: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func getCurrentWeatherData() {
        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(self.latitude)&lon=\(self.longitude)&appid=8c6787bccce2b30fe6f6a6a2e42d6a9e"
        print("-------------------------CurrentLocationAPI-------------------------------------------------")
        // Replace with your actual API URL
        
        NetworkManager.shared.fetchData(from: urlString, model: WeatherResponse.self) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let weatherResponse):
                    print("Weather data: \(weatherResponse)")
                    print("City: \(weatherResponse.name)")
                    //                           print("Temperature: \(weatherResponse.main.temp)")
                case .failure(let error):
                    print("Error fetching weather data: \(error.localizedDescription)")
                }
            }
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherTableViewCell", for: indexPath)
            
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherDetailTableViewCell", for: indexPath)
            return cell
        default :
            if let cell = tableView.dequeueReusableCell(withIdentifier: "RecentWeatherTableViewCell", for: indexPath) as? RecentWeatherTableViewCell {
                //  cell.setTableViewHeight()
                return cell
            }
        }
        return UITableViewCell()
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}


extension HomeViewController: MenuItemsTapped {
    
    func menuItemsAction(item: MenuItems) {
        switch item {
        case .home:
            print("Home")
        case .favourites:
            self.pushViewController(fromStoryboard: "Main", viewControllerID: "FavouriteViewController")
        case .recents:
            self.pushViewController(fromStoryboard: "Main", viewControllerID: "RecentSearchViewController")
        }
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
        //self.configureRefreshControl()
        pageTableViews[page].reloadData()
    }
}
