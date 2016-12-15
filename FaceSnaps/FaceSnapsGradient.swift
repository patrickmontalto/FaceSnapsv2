//
//  FaceSnapsGradient.swift
//  FaceSnaps
//
//  Created by Patrick Montalto on 12/14/16.
//  Copyright © 2016 Patrick Montalto. All rights reserved.
//

import UIKit

class FaceSnapsGradient: CAGradientLayer {
    
    init(parentView: UIView) {
        super.init()
        
        self.frame = parentView.bounds
        self.colors = [GradientLayerAnimator.color1, GradientLayerAnimator.color2]
        self.startPoint = CGPoint(x: 0.0, y: 0.5)
        self.endPoint = CGPoint(x: 1.0, y: 0.5)
    }
    
    override init(layer: Any) {
        super.init(layer: layer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
