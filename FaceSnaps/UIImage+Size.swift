//
//  UIImage+Size.swift
//  FaceSnaps
//
//  Created by Patrick Montalto on 1/25/17.
//  Copyright © 2017 Patrick Montalto. All rights reserved.
//

import UIKit

extension UIImage {
    func with(size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        let newRect = CGRect(origin: .zero, size: CGSize(width: size.width, height: size.height))
        self.draw(in: newRect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
}
