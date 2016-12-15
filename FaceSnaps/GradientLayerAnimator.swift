//
//  GradientLayerAnimator.swift
//  FaceSnaps
//
//  Created by Patrick Montalto on 11/30/16.
//  Copyright © 2016 Patrick Montalto. All rights reserved.
//

import Foundation
import UIKit

class GradientLayerAnimator: NSObject, CAAnimationDelegate {
    
    // Constants
    static let color1 = UIColor(red: 158/255, green: 50/255, blue: 122/255, alpha: 1.0).cgColor
    static let color2 = UIColor(red: 136/255, green: 56/255, blue: 136/255, alpha: 1.0).cgColor
    
    static let color3 = UIColor(red: 118/255, green: 73/255, blue: 156/255, alpha: 1.0).cgColor
    static let color4 = UIColor(red: 86/255, green: 96/255, blue: 173/255, alpha: 1.0).cgColor
    
    static let color5 = UIColor(red: 64/255, green: 112/255, blue: 182/255, alpha: 1.0).cgColor
    static let color6 = UIColor(red: 45/255, green: 118/255, blue: 181/255, alpha: 1.0).cgColor
    
    static let color7 = UIColor(red: 43/255, green: 107/255, blue: 152/255, alpha: 1.0).cgColor
    static let color8 = UIColor(red: 64/255, green: 92/255, blue: 124/255, alpha: 1.0).cgColor
    
    static let color9 = UIColor(red: 80/255, green: 88/255, blue: 112/255, alpha: 1.0).cgColor
    static let color10 = UIColor(red: 113/255, green: 77/255, blue: 88/255, alpha: 1.0).cgColor
    
    static let color11 = UIColor(red: 131/255, green: 72/255, blue: 79/255, alpha: 1.0).cgColor
    static let color12 = UIColor(red: 158/255, green: 63/255, blue: 68/255, alpha: 1.0).cgColor
    
    static let color13 = UIColor(red: 157/255, green: 64/255, blue: 68/255, alpha: 1.0).cgColor
    static let color14 = UIColor(red: 173/255, green: 54/255, blue: 67/255, alpha: 1.0).cgColor
    
    static let color15 = UIColor(red: 178/255, green: 51/255, blue: 70/255, alpha: 1.0).cgColor
    static let color16 = UIColor(red: 175/255, green: 46/255, blue: 88/255, alpha: 1.0).cgColor
    
    static let color17 = UIColor(red: 179/255, green: 45/255, blue: 88/255, alpha: 1.0).cgColor
    static let color18 = UIColor(red: 164/255, green: 48/255, blue: 113/255, alpha: 1.0).cgColor
    
    static let color19 = UIColor(red: 169/255, green: 45/255, blue: 107/255, alpha: 1.0).cgColor
    static let color20 = UIColor(red: 134/255, green: 54/255, blue: 127/255, alpha: 1.0).cgColor
    
    static let gradientColors = [
        [color1, color2],
        [color2, color3],
        [color3, color4],
        [color4, color5],
        [color5, color6],
        [color6, color7],
        [color7, color8],
        [color8, color9],
        [color9, color10],
        [color10, color11],
        [color11, color12],
        [color12, color13],
        [color13, color14],
        [color14, color15],
        [color15, color16],
        [color16, color17],
        [color17, color18],
        [color18, color19],
        [color19, color20],
        [color20, color1]
    ]
    
    var layer: CAGradientLayer!
    
    var toIndex: Int!
    
    var animationViewPosition: CAAnimation?
    
    init(layer: CAGradientLayer) {
        super.init()
        
        self.layer = layer
        toIndex = 1
        
        // Add observer for app moving into background and app resuming
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: Notification.Name.UIApplicationDidEnterBackground, object: nil)
        notificationCenter.addObserver(self, selector: #selector(appWillEnterForeground), name: Notification.Name.UIApplicationWillEnterForeground, object: nil)
    }
    
    
    func animateGradient()  {
        let fromColors = layer.colors
        let toColors = GradientLayerAnimator.gradientColors[toIndex]
        layer.colors = toColors
        
        let animation: CABasicAnimation = CABasicAnimation(keyPath: "colors")
        
        animation.fromValue = fromColors
        animation.toValue = toColors
        animation.duration = 3.00
        animation.isRemovedOnCompletion = true
        animation.fillMode = kCAFillModeForwards
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.delegate = self
        
        layer.add(animation, forKey: "animateGradient")
        
        // Set the index as the current index of the gradient's colors
        toIndex = (toIndex + 1) % GradientLayerAnimator.gradientColors.count
    }
    
    // Continuously execute the animation
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag {
            animateGradient()
        }
    }
    
    // Observe when the app moves to background to save the animation position
    func appMovedToBackground() {
        animationViewPosition = layer.animation(forKey: "animateGradient")
        pauseLayer(layer: layer) // Apple's method from QA1673
    }
    
    // Observe when the app moves to foreground to resume the animation
    func appWillEnterForeground() {
        if let viewPosition = animationViewPosition  {
            layer.add(viewPosition, forKey: "animateGradient")
            animationViewPosition = nil
        }
        resumeLayer(layer: layer) // Apple's method from QA1673
    }
    
    // Set the timeOffset on the layer using the current absolute time
    func pauseLayer(layer: CALayer) {
        let pausedTime = layer.convertTime(CACurrentMediaTime(), from: nil)
        layer.speed = 0.0
        layer.timeOffset = pausedTime
    }
    
    // Resume the layer animation using timeOffset and pausedTime
    func resumeLayer(layer: CALayer) {
        let pausedTime = layer.timeOffset
        layer.speed = 1
        layer.timeOffset = 0
        layer.beginTime = 0
        let timeSincePause = layer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        layer.beginTime = timeSincePause
    }

}
