//
//  CellAnimator.swift
//  FaceSnaps
//
//  Created by Patrick Montalto on 10/14/16.
//  Copyright © 2016 Patrick Montalto. All rights reserved.
//

import Foundation
import UIKit

struct CellAnimator {
    
    // Constants
    static let kWiggleBounceY = 4.0
    static let kWiggleBounceDuration = 0.12
    static let kWiggleBounceDurationVariance = 0.025
    static let kWiggleRotateAngle = 0.06
    static let kWiggleRotateDuration = 0.1
    static let kWiggleRotateDurationVariance = 0.025
    
    // Animate all cells in collectionView
    static func animateAllCells(inCollectionView collectionView: UICollectionView) {
        for cell in collectionView.visibleCells {
            startWiggling(view: cell)
        }
    }
    
    // Stop animating all cells in collectionView
    static func stopAnimatingAllCells(inCollectionView collectionView: UICollectionView) {
        let _ = collectionView.visibleCells.map { stopWiggling(view: $0) }
    }
    
    // Begin wiggling animation on UIView
    static func startWiggling(view: UIView) {
        UIView.animate(withDuration: 0) { 
            view.layer.add(rotationAnimation, forKey: "rotation")
            view.layer.add(bounceAnimation, forKey: "bounce")
            view.transform = .identity
        }
    }
    
    // Remove animations from UIView
    static func stopWiggling(view: UIView) {
        view.layer.removeAnimation(forKey: "rotation")
        view.layer.removeAnimation(forKey: "bounce")
    }
    
    static let rotationAnimation: CAAnimation = {
        let animation = CAKeyframeAnimation(keyPath: "transform.rotation.z")
        animation.values = [-kWiggleRotateAngle, kWiggleRotateAngle]
        
        animation.autoreverses = true
        animation.duration = randomize(interval: kWiggleRotateDuration, withVariance: kWiggleRotateDurationVariance)
        animation.repeatCount = Float.infinity
        
        return animation
    }()
    
    static let bounceAnimation: CAAnimation = {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.y")
        animation.values = [kWiggleBounceY, 0.0]
        
        animation.autoreverses = true
        animation.duration = randomize(interval: kWiggleBounceDuration, withVariance: kWiggleBounceDurationVariance)
        animation.repeatCount = Float.infinity
        
        return animation
    }()
    
    static func randomize(interval: TimeInterval, withVariance variance: Double) -> TimeInterval {
        let random = (Double(arc4random_uniform(1000)) - 500.0) / 500.0
        return interval + variance * random
    }
}
