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
    
    convenience init(touchPoint: CGPoint) {
        self.init()

    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Update the location of the view based on the touchPoint
    func updatePoint(_ touchPoint:CGPoint) {
        let diameter: CGFloat = 48.0
        let frame = CGRect(x: touchPoint.x - diameter / 2, y: touchPoint.y - diameter / 2, width: diameter, height: diameter)
        self.frame = frame
    }
}
