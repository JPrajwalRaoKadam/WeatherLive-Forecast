//
//  LoaderManager.swift
//  WeatherLive-Forecast
//
//  Created by Prajwal rao Kadam J on 25/10/24.
//

import UIKit

// MARK: - LoaderManager
class LoaderManager {
    static let shared = LoaderManager()
    private var loaderView: UIView?
    private var activityIndicator: UIActivityIndicatorView?
    
    private init() {}
    
    func showLoader(on view: UIView) {
        // Create loader view
        loaderView = UIView(frame: view.bounds)
        loaderView?.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        
        // Create activity indicator
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator?.color = .white
        activityIndicator?.center = loaderView?.center ?? .zero
        activityIndicator?.startAnimating()
        
        if let loaderView = loaderView, let activityIndicator = activityIndicator {
            loaderView.addSubview(activityIndicator)
            view.addSubview(loaderView)
            
            // Add constraints
            loaderView.translatesAutoresizingMaskIntoConstraints = false
            activityIndicator.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                loaderView.topAnchor.constraint(equalTo: view.topAnchor),
                loaderView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                loaderView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                loaderView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                
                activityIndicator.centerXAnchor.constraint(equalTo: loaderView.centerXAnchor),
                activityIndicator.centerYAnchor.constraint(equalTo: loaderView.centerYAnchor)
            ])
        }
    }
    
    func hideLoader() {
        DispatchQueue.main.async {
            self.activityIndicator?.stopAnimating()
            self.loaderView?.removeFromSuperview()
            self.loaderView = nil
            self.activityIndicator = nil
        }
    }
}
