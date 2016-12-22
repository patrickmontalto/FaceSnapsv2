//
//  UIColor.swift
//  FaceSnaps
//
//  Created by Patrick Montalto on 12/21/16.
//  Copyright © 2016 Patrick Montalto. All rights reserved.
//

import UIKit

extension UIColor {
    open class var extraLightGray: UIColor {
        get {
            return UIColor(white: 245/255, alpha: 0.8)
        }
    }
    
    open class var superLightGray: UIColor {
        get {
            return UIColor.white.withAlphaComponent(0.1)
        }
    }
}
