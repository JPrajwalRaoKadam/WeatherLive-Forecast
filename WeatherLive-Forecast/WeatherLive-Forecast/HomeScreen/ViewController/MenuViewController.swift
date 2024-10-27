//
//  MenuViewController.swift
//  WeatherLive-Forecast
//
//  Created by Prajwal rao Kadam J on 24/10/24.
//

import UIKit

protocol MenuItemsTapped: AnyObject {
    func menuItemsAction(item: MenuItems)
}

enum MenuItems {
    case home
    case recents
    case favourites
}

class HamburgerMenu: UIView {
    
    var isMenuVisible = false
    let menuWidth: CGFloat = UIScreen.main.bounds.width * 0.65 // 65% width of the screen
    let buttonHeight: CGFloat = 50
    let spacing: CGFloat = 20
    
    weak var viewController: UIViewController?
    private var overlayView: UIView! // Add overlay view
    
    private var menuItems: MenuItems = .home
    weak var delegate: MenuItemsTapped?
    
    // Initialize with frame
    init() {
        super.init(frame: CGRect(x: -menuWidth, y: 50, width: menuWidth, height: UIScreen.main.bounds.height - 50))
        setupMenu()
        setupOverlay()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Setup the overlay view
    private func setupOverlay() {
        overlayView = UIView(frame: UIScreen.main.bounds)
        overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.5) // Semi-transparent black
        overlayView.alpha = 0
    }
    
    // Setup the sliding menu
    private func setupMenu() {
        self.backgroundColor = .white
        self.layer.zPosition = 1001 // Ensure menu stays above overlay
        
        // Add buttons or labels to the menu
        let buttonTitles = ["Home", "Favourites", "Recently Searched"]
        
        for (index, title) in buttonTitles.enumerated() {
            let button = UIButton(type: .system)
            button.setTitle(title, for: .normal)
            button.contentHorizontalAlignment = .left
            button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
            button.setTitleColor(UIColor.systemPurple, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
            button.frame = CGRect(x: 0, y: CGFloat(index) * (buttonHeight + spacing) + spacing, width: menuWidth, height: buttonHeight)
            button.addTarget(self, action: #selector(menuButtonTapped(_:)), for: .touchUpInside)
            button.tag = index + 1
            self.addSubview(button)
            
            if index < buttonTitles.count - 1 {
                let separator = UIView(frame: CGRect(x: 0, y: button.frame.maxY, width: menuWidth, height: 1))
                separator.backgroundColor = .darkGray
                self.addSubview(separator)
            }
        }
    }
    
    // Toggle menu visibility
    func toggleMenu(on viewController: UIViewController) {
        self.viewController = viewController
        isMenuVisible.toggle()
        
        // Add overlay to the main view if not already added
        if overlayView.superview == nil {
            viewController.view.insertSubview(overlayView, belowSubview: self)
        }
        
        if isMenuVisible {
            // Add tap gesture recognizer to the overlay view instead of main view
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapOutsideMenu(_:)))
            overlayView.addGestureRecognizer(tapGesture)
            overlayView.isUserInteractionEnabled = true
        } else {
            // Remove gesture recognizers from overlay
            if let gestures = overlayView.gestureRecognizers {
                for gesture in gestures {
                    overlayView.removeGestureRecognizer(gesture)
                }
            }
        }
        
        UIView.animate(withDuration: 0.3) {
            self.frame.origin.x = self.isMenuVisible ? 0 : -self.menuWidth
            self.overlayView.alpha = self.isMenuVisible ? 1 : 0
        }
    }
    
    // Handle button tap events
    @objc func menuButtonTapped(_ sender: UIButton) {
        print("Action \(sender.tag) tapped")
        
        switch sender.tag {
        case 1:
            closeMenu()
            self.delegate?.menuItemsAction(item: .home)
        case 2:
            closeMenu()
            self.delegate?.menuItemsAction(item: .favourites)
        case 3:
            closeMenu()
            self.delegate?.menuItemsAction(item: .recents)
        default:
            break
        }
    }
    
    // Tap outside menu to close
    @objc func tapOutsideMenu(_ sender: UITapGestureRecognizer) {
        closeMenu()
    }
    
    // Function to close the menu
    func closeMenu() {
        UIView.animate(withDuration: 0.3) {
            self.frame.origin.x = -self.menuWidth
            self.overlayView.alpha = 0
        } completion: { _ in
            // Remove overlay view when animation completes
            self.overlayView.removeFromSuperview()
        }
        
        isMenuVisible = false
        
        // Remove gesture recognizers from overlay
        if let gestures = overlayView.gestureRecognizers {
            for gesture in gestures {
                overlayView.removeGestureRecognizer(gesture)
            }
        }
    }
}
