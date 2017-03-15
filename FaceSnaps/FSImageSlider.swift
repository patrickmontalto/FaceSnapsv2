//
//  FSImageSlider.swift
//  FaceSnaps
//
//  Created by Patrick Montalto on 3/14/17.
//  Copyright © 2017 Patrick Montalto. All rights reserved.
//

import UIKit

class FSImageSlider: UISlider {
    
    // MARK: - Properties
    var centered: Bool!
    
    var leftSelectedViewLeftAnchorConstraint: NSLayoutConstraint?
    var rightSelectedViewRightAnchorConstraint: NSLayoutConstraint?
    var valueLabelCenterXAnchorConstraint: NSLayoutConstraint?
    var valueLabelBottomAnchorConstraint: NSLayoutConstraint?
    
    var hasLoadedConstraints = false
    
    lazy var valueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 12.0)
        return label
    }()
    
    lazy var leftSelectedTrackView: UIImageView = {
        let img = UIImage(named: "selected_track")!
        let imgView = UIImageView(image: img)
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.isHidden = true
        return imgView
    }()
    lazy var rightSelectedTrackView: UIImageView = {
        let img = UIImage(named: "selected_track")!
        let imgView = UIImageView(image: img)
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.isHidden = true
        return imgView
    }()
    lazy var centerSliderIndicator: UIImageView = {
        let img = UIImage(named: "center_slider_indicator")!
        let imgView = UIImageView(image: img)
        imgView.translatesAutoresizingMaskIntoConstraints = false
        return imgView
    }()
    
    // MARK: - Initializer
    convenience init(centered: Bool) {
        self.init()
        self.centered = centered
        addSubview(valueLabel)
        addSubview(centerSliderIndicator)
        self.addTarget(self, action: #selector(valueChanged), for: .valueChanged)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        if !hasLoadedConstraints {
            hasLoadedConstraints = true
            
            insertSubview(leftSelectedTrackView, at: 4)
            insertSubview(rightSelectedTrackView, at: 4)
    
            NSLayoutConstraint.activate([
                centerSliderIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                centerSliderIndicator.topAnchor.constraint(equalTo: self.centerYAnchor, constant: -8),
                leftSelectedTrackView.heightAnchor.constraint(equalToConstant: 2),
                leftSelectedTrackView.rightAnchor.constraint(equalTo: self.centerXAnchor),
                leftSelectedTrackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 15),
                
                rightSelectedTrackView.heightAnchor.constraint(equalToConstant: 2),
                rightSelectedTrackView.leftAnchor.constraint(equalTo: self.centerXAnchor),
                rightSelectedTrackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 15),
            ])
        }
    }

    override func minimumTrackImage(for state: UIControlState) -> UIImage? {
        return UIImage(named: "unselected_track")
    }
    
    override func maximumTrackImage(for state: UIControlState) -> UIImage? {
        return UIImage(named: "unselected_track")
    }
    
    func valueChanged() {
        let thumbView = self.subviews.last!
        leftSelectedViewLeftAnchorConstraint = leftSelectedTrackView.leftAnchor.constraint(equalTo: thumbView.centerXAnchor)
        rightSelectedViewRightAnchorConstraint = rightSelectedTrackView.rightAnchor.constraint(equalTo: thumbView.centerXAnchor)
        
        leftSelectedViewLeftAnchorConstraint?.isActive = true
        rightSelectedViewRightAnchorConstraint?.isActive = true
        
        if value < 0 {
            leftSelectedTrackView.isHidden = false
            rightSelectedTrackView.isHidden = true
        } else if value > 0 {
            leftSelectedTrackView.isHidden = true
            rightSelectedTrackView.isHidden = false
        } else {
            leftSelectedTrackView.isHidden = true
            rightSelectedTrackView.isHidden = true
        }
        
        if value == maximumValue || value == minimumValue || value == 0 {
            generateFeedback()
        }
        
        valueLabel.centerXAnchor.constraint(equalTo: thumbView.centerXAnchor).isActive = true
        
        valueLabelCenterXAnchorConstraint = valueLabel.centerXAnchor.constraint(equalTo: thumbView.centerXAnchor)
        valueLabelCenterXAnchorConstraint?.isActive = true
        valueLabelBottomAnchorConstraint = valueLabel.bottomAnchor.constraint(equalTo: thumbView.topAnchor, constant: -8)
        valueLabelBottomAnchorConstraint?.isActive = true
        
        let sliderValue = Int(roundf(value))
        
        valueLabel.text = sliderValue == 0 ? nil : "\(sliderValue)"
    }
    
    private func generateFeedback() {
        let generator = UISelectionFeedbackGenerator()
        generator.prepare()
        generator.selectionChanged()
    }
    
}
