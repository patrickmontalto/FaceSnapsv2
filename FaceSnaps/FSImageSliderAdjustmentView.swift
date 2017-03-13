//
//  FSImageSliderAdjustmentView.swift
//  FaceSnaps
//
//  Created by Patrick Montalto on 3/12/17.
//  Copyright © 2017 Patrick Montalto. All rights reserved.
//

import UIKit

enum FSImageSliderType: Int {
    case brightness, contrast, structure
}

class FSImageSliderAdjustmentView: UIView {
    
    // MARK: - Properties
    var slider: UISlider!
    var delegate: FSImageEditViewDelegate!
    var type: FSImageSliderType!
    
    // MARK: - Initializer
    convenience init(delegate: FSImageEditViewDelegate, type: FSImageSliderType) {
        self.init()
        // Hide view by default
        isHidden = true
        backgroundColor = .white
        translatesAutoresizingMaskIntoConstraints = false
        
        // Set properties
        self.slider = UISlider()
        self.delegate = delegate
        self.type = type
        
        // Set slider values
        slider.value = 0
        
        switch type {
        case .brightness, .contrast:
            slider.minimumValue = -100
            slider.maximumValue = 100
        case .structure:
            slider.minimumValue = 0
            slider.maximumValue = 100
        }
        
        // Set slider targets
        slider.addTarget(self, action: #selector(sliderMoved(sender:)), for: .touchUpInside)
        slider.addTarget(self, action: #selector(sliderMoved(sender:)), for: .touchUpOutside)
        
        // Layout
        addSubview(slider)
        slider.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            slider.centerYAnchor.constraint(equalTo: centerYAnchor),
            slider.leftAnchor.constraint(equalTo: leftAnchor, constant: 30),
            slider.rightAnchor.constraint(equalTo: rightAnchor, constant: -30),
        ])
    }
    
    func sliderMoved(sender: UISlider) {
        switch type! {
        case .brightness:
            delegate.brightnessSliderMove(sender: sender)
        case .contrast:
            delegate.contrastSliderMove(sender: sender)
        case .structure:
            delegate.structureSliderMove(sender: sender)
        }
    }
}
