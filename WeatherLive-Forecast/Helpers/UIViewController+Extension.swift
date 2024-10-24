//
//  UIViewController+Extension.swift
//  WeatherLive-Forecast
//
//  Created by Prajwal rao Kadam J on 24/10/24.
//


import UIKit

extension UIViewController {

    /// Reusable method to push a view controller from storyboard
    /// - Parameters:
    ///   - storyboardName: The name of the storyboard where the view controller is located.
    ///   - viewControllerID: The storyboard ID of the view controller you want to push.
    ///   - animated: A boolean value that determines whether the push should be animated.
    func pushViewController(fromStoryboard storyboardName: String, viewControllerID: String, animated: Bool = true) {
        // Access the storyboard by name
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        
        // Instantiate the view controller using its identifier (this will never return nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: viewControllerID)
        
        // Push the view controller onto the navigation stack
        self.navigationController?.pushViewController(viewController, animated: animated)
    }
}

