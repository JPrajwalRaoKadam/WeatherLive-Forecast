//
//  SearchVIewController.swift
//  WeatherLive-Forecast
//
//  Created by Prajwal rao Kadam J on 24/10/24.
//

import UIKit

class CitySearchViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {

    let searchBar = UISearchBar()
    let tableView = UITableView()
    
    // Sample list of city names
    var cityNames: [String] = []
    var filteredCities: [String] = []
    var searchText: String = "" // Store the current search text
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.cityNames = worldCities
        view.backgroundColor = .white
        
        // Setup the navigation bar
        setupNavigationBar()
        
        // Setup the search bar
        searchBar.delegate = self
        searchBar.placeholder = "Enter city name"
        searchBar.sizeToFit()
        view.addSubview(searchBar)
        
        // Setup the table view
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cityCell")
        view.addSubview(tableView)
        
        // Layout the search bar and table view
        setupLayout()
        self.navigationController?.isNavigationBarHidden = false
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Update the layout in case of device rotation
        setupLayout()
    }

    private func setupLayout() {
        // Get the safe area insets
        let safeAreaInsets = view.safeAreaInsets

        // Position the search bar 20 points below the safe area
        let searchBarHeight: CGFloat = 44 // Default height for UISearchBar
        searchBar.frame = CGRect(x: 0,
                                 y: safeAreaInsets.top + 20,
                                 width: view.frame.width,
                                 height: searchBarHeight)

        // Setup the table view below the search bar
        tableView.frame = CGRect(x: 0,
                                 y: searchBar.frame.maxY,
                                 width: view.frame.width,
                                 height: view.frame.height - searchBar.frame.maxY - safeAreaInsets.bottom)
    }
    
    private func setupNavigationBar() {
        // Set the title of the navigation bar
        title = "City Search"
        
        // Create a back button
        let backButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backButtonTapped))
        navigationItem.leftBarButtonItem = backButton
        
        // Create a search button
        let searchButton = UIBarButtonItem(title: "Search", style: .plain, target: self, action: #selector(searchButtonTapped))
        navigationItem.rightBarButtonItem = searchButton
    }
    
    @objc private func backButtonTapped() {
        // Handle back button action
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func searchButtonTapped() {
        // Handle search button action (for example, perform the search manually)
        print("Search button tapped") // You can add your search logic here
    }

    // UISearchBarDelegate method: called when text is typed
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchText = searchText // Update the search text
        // Filter cities based on search text
        if searchText.count > 0 {  // Start filtering after 0 characters
            filteredCities = cityNames.filter { $0.lowercased().contains(searchText.lowercased()) }
        } else {
            filteredCities = []
        }
        tableView.reloadData()
    }
    
    // TableView DataSource methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredCities.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cityCell", for: indexPath)
        
        let cityName = filteredCities[indexPath.row]
        cell.textLabel?.attributedText = highlightText(in: cityName, for: searchText) // Set highlighted text
        return cell
    }

    // Function to highlight search text in the city name
    private func highlightText(in cityName: String, for searchText: String) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: cityName)
        guard !searchText.isEmpty else { return attributedString }
        
        let range = (cityName as NSString).range(of: searchText, options: .caseInsensitive)
        if range.location != NSNotFound {
            attributedString.addAttribute(.foregroundColor, value: UIColor.systemBlue, range: range) // Highlight color
            attributedString.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 17), range: range) // Bold font
        }
        
        return attributedString
    }

    // TableView Delegate method: called when a city is selected
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCity = filteredCities[indexPath.row]
        searchBar.text = selectedCity  // Set the selected city name in the search bar
        searchBar.resignFirstResponder()  // Dismiss the keyboard
        filteredCities = []  // Clear suggestions
        tableView.reloadData()  // Reload table view to clear suggestions
    }
}

