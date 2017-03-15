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
    
    var stringRepresentation: String {
        switch self {
        case .brightness:
            return "Brightness"
        case .contrast:
            return "Contrast"
        case .structure:
            return "Structure"
        }
    }
}

class FSImageSliderAdjustmentView: UIView {
    
    // MARK: - Properties
    var slider: FSImageSlider!
    var hasLoadedConstraints = false
    var delegate: FSImageEditViewDelegate!
    var type: FSImageSliderType!
    var lastValue: Float = 0
    
    // MARK: - Initializer
    convenience init(delegate: FSImageEditViewDelegate, type: FSImageSliderType) {
        self.init()
        // Hide view by default
        isHidden = true
        backgroundColor = .white
        translatesAutoresizingMaskIntoConstraints = false
        
        // Set properties
        let centered = !(type == .structure)
        self.slider = FSImageSlider(centered: centered)
        
        self.delegate = delegate
        self.type = type
        
        // Set slider values
        slider.value = lastValue

        switch type {
        case .brightness, .contrast:
            slider.minimumValue = -100
            slider.maximumValue = 100
        case .structure:
            slider.minimumValue = 0
            slider.maximumValue = 100
        }
        
        // Set slider targets        
        slider.addTarget(self, action: #selector(sliderMoved(sender:)), for: .valueChanged)

        // Layout
        addSubview(slider)
        slider.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func updateConstraints() {
        if !hasLoadedConstraints {
            hasLoadedConstraints = true
            
            NSLayoutConstraint.activate([
                slider.centerYAnchor.constraint(equalTo: centerYAnchor),
                slider.leftAnchor.constraint(equalTo: leftAnchor, constant: 30),
                slider.rightAnchor.constraint(equalTo: rightAnchor, constant: -30),
            ])
        }
        
        super.updateConstraints()
    }
        
    var valueLabelCenterXAnchorConstraint: NSLayoutConstraint?
    var valueLabelBottomAnchorConstraint: NSLayoutConstraint?

    
    func sliderMoved(sender: FSImageSlider) {
        switch type! {
        case .brightness:
            delegate.brightnessSliderMove(sender: sender)
        case .contrast:
            delegate.contrastSliderMove(sender: sender)
        case .structure:
            delegate.structureSliderMove(sender: sender)
        }
        
        sender.valueChanged()
    }
}
