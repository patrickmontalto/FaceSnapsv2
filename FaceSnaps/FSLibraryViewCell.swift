//
//  FSLibraryViewCell.swift
//  FaceSnaps
//
//  Created by Patrick Montalto on 3/5/17.
//  Copyright © 2017 Patrick Montalto. All rights reserved.
//

import UIKit

class FSLibraryViewCell: UICollectionViewCell {
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var highlightView: UIView!
    
    var image: UIImage? {
        didSet {
            self.imageView.image = image
        }
    }

    override var isSelected: Bool {
        didSet {
            self.highlightView.isHidden = !isSelected
        }
    }
}
