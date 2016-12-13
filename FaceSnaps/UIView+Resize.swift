//
//  UIView+Resize.swift
//  FaceSnaps
//
//  Created by Patrick Montalto on 12/12/16.
//  Copyright © 2016 Patrick Montalto. All rights reserved.
//

import UIKit

extension UIView {
    func resizeToFitSubviews() {
        var width: CGFloat = 0
        var height: CGFloat = 0
        for view in self.subviews {
            let aView = view
            let newWidth = aView.frame.origin.x + aView.frame.width
            let newHeight = aView.frame.origin.y + aView.frame.height
            width = max(width, newWidth)
            height = max(height, newHeight)
        }
        
        frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: width, height: height)
    }
}
