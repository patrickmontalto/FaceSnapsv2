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
    var slider: UISlider!
    var delegate: FSImageEditViewDelegate!
    var type: FSImageSliderType!
    var lastValue: Float = 0
    lazy var valueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 12.0)
        return label
    }()
    
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
        addSubview(valueLabel)
        slider.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
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
        
        let handleView = slider.subviews.last as! UIImageView
        NSLayoutConstraint.activate([
            valueLabel.centerXAnchor.constraint(equalTo: handleView.centerXAnchor),
            valueLabel.bottomAnchor.constraint(equalTo: handleView.topAnchor, constant: -8),
        ])

        let sliderValue = Int(roundf(sender.value))

        valueLabel.text = sliderValue == 0 ? nil : "\(sliderValue)"
    }
}
