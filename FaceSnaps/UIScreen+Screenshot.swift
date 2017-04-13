//
//  UIScreen+Screenshot.swift
//  FaceSnaps
//
//  Created by Patrick on 4/13/17.
//  Copyright © 2017 Patrick Montalto. All rights reserved.
//

import UIKit

extension UIScreen {
    
    static func screenshot() -> UIImage {
        let view = main.snapshotView(afterScreenUpdates: false)
        
        UIGraphicsBeginImageContext(view.bounds.size)
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        
        let screenshot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return screenshot!
    }
}
