//
//  ReusableClass.swift
//  WeatherLive-Forecast
//
//  Created by Prajwal rao Kadam J on 24/10/24.
//
import UIKit

class ToggleButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setToggleButtonProperties()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.setToggleButtonProperties()

    }
    
    func setToggleButtonProperties() {
        
        self.setImage(UIImage(systemName: "heart"), for: .normal)
        self.setImage(UIImage(systemName: "heart.fill"), for: .selected)
        
        self.isSelected = false
        
        self.addTarget(self, action: #selector(toggle), for: .touchUpInside)

    }
    
    @objc func toggle() {
        
        self.isSelected = !self.isSelected
    }
}
