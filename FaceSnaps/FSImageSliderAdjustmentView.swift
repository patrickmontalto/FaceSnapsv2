//
//  FSImageSliderAdjustmentView.swift
//  FaceSnaps
//
//  Created by Patrick Montalto on 3/12/17.
//  Copyright © 2017 Patrick Montalto. All rights reserved.
//

import UIKit



class FSImageSliderAdjustmentView: UIView {
    
    // MARK: - Properties
    var slider: FSImageSlider!
    var hasLoadedConstraints = false
    var delegate: FSImageEditViewDelegate!
    var type: FSImageAdjustmentType!
    var lastValue: Float = 0
    
    // MARK: - Initializer
    convenience init(delegate: FSImageEditViewDelegate, type: FSImageAdjustmentType) {
        self.init()
        // Set tag
        self.tag = type.rawValue
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
        case .structure, .vignette:
            slider.minimumValue = 0
            slider.maximumValue = 100
        default:
            slider.minimumValue = -100
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
        if sender.currentRoundedValue == sender.lastRoundedValue { return }
//        sender.valueChanged()
//        print(sender.currentRoundedValue)
        sender.updateTrackingView()
        
        switch type! {
        case .brightness:
            delegate.brightnessSliderMove(sender: sender)
        case .contrast:
            delegate.contrastSliderMove(sender: sender)
        case .structure:
            delegate.structureSliderMove(sender: sender)
        case .warmth:
            delegate.warmthSliderMove(sender: sender)
        case .saturation:
            delegate.saturationSliderMove(sender: sender)
        case .highlights:
            delegate.highlightsSliderMove(sender: sender)
        case .shadows:
            delegate.shadowsSliderMove(sender: sender)
        case .vignette:
            delegate.vignetteSliderMove(sender: sender)
        case .tiltshift:
            return
        }
        
        sender.lastRoundedValue = sender.currentRoundedValue
        
    }
}
