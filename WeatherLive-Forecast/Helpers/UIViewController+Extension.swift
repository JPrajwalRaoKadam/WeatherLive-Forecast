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

extension UIViewController {
    func pushViewControllerNew(withIdentifier identifier: String, storyboardName: String = "Main") {
        // Get storyboard instance
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        
        // Instantiate view controller from storyboard
        guard let destinationVC = storyboard.instantiateViewController(withIdentifier: identifier) as? UIViewController else {
            print("Error: Could not instantiate view controller with identifier: \(identifier)")
            return
        }
        
        // Push the view controller
        self.navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    // Method with data passing capability
    func pushViewControllerNew<T: UIViewController>(withIdentifier identifier: String,
                                                       storyboardName: String = "Main",
                                                       prepare: ((T) -> Void)? = nil) {
            let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
            
            guard let destinationVC = storyboard.instantiateViewController(withIdentifier: identifier) as? T else {
                print("Error: Could not instantiate view controller with identifier: \(identifier)")
                return
            }
            
            // Add closure to be executed after view is loaded
            if let prepare = prepare {
                destinationVC.loadViewIfNeeded() // Force load the view hierarchy
                prepare(destinationVC)
            }
            
            // Ensure we're pushing from the main thread
            DispatchQueue.main.async {
                self.navigationController?.pushViewController(destinationVC, animated: true)
            }
        }
}
