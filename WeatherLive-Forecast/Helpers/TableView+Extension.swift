//
//  TableView+Extension.swift
//  WeatherLive-Forecast
//
//  Created by Prajwal rao Kadam J on 24/10/24.
//

import UIKit

// MARK: - Reusable Extension for UITableView
extension UITableView {
    
    /// Register a UITableViewCell using its class type
    func register<T: UITableViewCell>(cellType: T.Type) {
        let className = String(describing: cellType)
        let nib = UINib(nibName: className, bundle: nil)
        self.register(nib, forCellReuseIdentifier: className)
    }
    
    /// Register a UITableViewHeaderFooterView using its class type
    func register<T: UITableViewHeaderFooterView>(headerFooterViewType: T.Type) {
        let className = String(describing: headerFooterViewType)
        let nib = UINib(nibName: className, bundle: nil)
        self.register(nib, forHeaderFooterViewReuseIdentifier: className)
    }
    
    /// Dequeue reusable cell with inferred type
    func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T {
        let className = String(describing: T.self)
        guard let cell = dequeueReusableCell(withIdentifier: className, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(className)")
        }
        return cell
    }
    
    /// Dequeue reusable header/footer view with inferred type
    func dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView>() -> T {
        let className = String(describing: T.self)
        guard let view = dequeueReusableHeaderFooterView(withIdentifier: className) as? T else {
            fatalError("Could not dequeue header/footer view with identifier: \(className)")
        }
        return view
    }
}

