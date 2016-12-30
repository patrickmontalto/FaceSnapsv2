//
//  UIButton+setImage.swift
//  FaceSnaps
//
//  Created by Patrick Montalto on 12/30/16.
//  Copyright © 2016 Patrick Montalto. All rights reserved.
//

import UIKit

extension UIButton {
    
    func setImage(image: UIImage?, inFrame frame: CGRect?, forState state: UIControlState) {
        self.setImage(image, for: state)
        
        if let frame = frame {
            self.imageEdgeInsets = UIEdgeInsets(
                top: frame.minY - self.frame.minY,
                left: frame.minX - self.frame.minX,
                bottom: self.frame.maxY - frame.maxY,
                right: self.frame.maxX - frame.maxX
            )
        }
    }
}
