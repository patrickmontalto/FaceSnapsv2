//
//  UIView+SnapshotView.swift
//  FaceSnaps
//
//  Created by Patrick on 4/13/17.
//  Copyright © 2017 Patrick Montalto. All rights reserved.
//

import UIKit

extension UIView {
    func snapshotImageView() -> UIImageView {
        let image = UIScreen.screenshot()
        
        let imageView = UIImageView(image: image)
        imageView.frame = self.bounds
        
        return imageView
    }
}
