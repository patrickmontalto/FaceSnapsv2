//
//  CameraFocusView.swift
//  FaceSnaps
//
//  Created by Patrick Montalto on 12/30/16.
//  Copyright © 2016 Patrick Montalto. All rights reserved.
//

import UIKit

class CameraFocusView: UIView, CAAnimationDelegate {
    internal let kSelectionAnimation: String = "selectionAnimation"
    private var selectionPulse: CABasicAnimation?
    
    lazy var innerFocus: UIImageView = {
        let image = UIImage(named: "inner_focus")!

        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var outerFocus: UIImageView = {
        let image = UIImage(named: "outer_focus_1")!
        
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    convenience init(touchPoint: CGPoint) {
        self.init()
        updatePoint(touchPoint)
        backgroundColor = .clear
        isHidden = true
        initializeSubViews()
        
        // Add constraints
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 60),
            widthAnchor.constraint(equalToConstant: 60),
        ])
        
        initializePulse()
    }
    
    private func initializeSubViews() {
        // Add subviews
        addSubview(innerFocus)
        addSubview(outerFocus)
        
        NSLayoutConstraint.activate([
            innerFocus.centerXAnchor.constraint(equalTo: centerXAnchor),
            innerFocus.centerYAnchor.constraint(equalTo: centerYAnchor),
            innerFocus.heightAnchor.constraint(equalToConstant: 28),
            innerFocus.widthAnchor.constraint(equalToConstant: 28),
            outerFocus.centerXAnchor.constraint(equalTo: centerXAnchor),
            outerFocus.centerYAnchor.constraint(equalTo: centerYAnchor),
            outerFocus.widthAnchor.constraint(equalToConstant: 48),
            outerFocus.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")

    }
    
    // MARK: Initialize the pulse animation
    private func initializePulse() {
        selectionPulse = CABasicAnimation(keyPath: "transform.scale")
        selectionPulse?.autoreverses = true
        selectionPulse?.repeatCount = 1
        selectionPulse?.fromValue = 1
        selectionPulse?.toValue = 1.25
        selectionPulse?.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        selectionPulse?.delegate = self
    }
    
    // MARK: Update the location of the view based on the touchPoint
    func updatePoint(_ touchPoint:CGPoint) {
        let diameter: CGFloat = 48.0
        let frame = CGRect(x: touchPoint.x - diameter / 2, y: touchPoint.y - diameter / 2, width: diameter, height: diameter)
        self.frame = frame
    }
    
    // MARK: Unhides the view and initiates animation by adding it to the layer
    func animateFocusingAction() {
        if let selectionPulse = selectionPulse {
            // Make the view visible
            alpha = 1.0
            isHidden = false
            // Initiate animation
            outerFocus.layer.add(selectionPulse, forKey: kSelectionAnimation)
        }
    }

    // MARK: Hides the view after the animation stops.
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        // TODO: How to make it shrink? Add another animation ?
        // Hide the view
        alpha = 0.0
        isHidden = true
    }
}







