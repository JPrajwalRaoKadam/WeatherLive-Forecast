//
//  CollectionView+Extension.swift
//  WeatherLive-Forecast
//
//  Created by Prajwal rao Kadam J on 24/10/24.
//

// MARK: - Reusable Extension for UICollectionView
import UIKit

extension UICollectionView {
    
    /// Register a UICollectionViewCell using its class type
    func register<T: UICollectionViewCell>(cellType: T.Type) {
        let className = String(describing: cellType)
        let nib = UINib(nibName: className, bundle: nil)
        self.register(nib, forCellWithReuseIdentifier: className)
    }
    
    /// Register a UICollectionReusableView (header/footer) using its class type
    func register<T: UICollectionReusableView>(reusableViewType: T.Type, forSupplementaryViewOfKind kind: String) {
        let className = String(describing: reusableViewType)
        let nib = UINib(nibName: className, bundle: nil)
        self.register(nib, forSupplementaryViewOfKind: kind, withReuseIdentifier: className)
    }
    
    /// Dequeue reusable cell with inferred type
    func dequeueReusableCell<T: UICollectionViewCell>(for indexPath: IndexPath) -> T {
        let className = String(describing: T.self)
        guard let cell = dequeueReusableCell(withReuseIdentifier: className, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(className)")
        }
        return cell
    }
    
    /// Dequeue reusable supplementary view (header/footer) with inferred type
    func dequeueReusableSupplementaryView<T: UICollectionReusableView>(ofKind kind: String, for indexPath: IndexPath) -> T {
        let className = String(describing: T.self)
        guard let view = dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: className, for: indexPath) as? T else {
            fatalError("Could not dequeue supplementary view with identifier: \(className)")
        }
        return view
    }
}


