//
//  FSImageEditViewCell.swift
//  FaceSnaps
//
//  Created by Patrick Montalto on 3/12/17.
//  Copyright © 2017 Patrick Montalto. All rights reserved.
//

import UIKit

class FSImageEditViewCell: UICollectionViewCell {
    
    var mode: TiltShiftMode?
    
    @IBOutlet var label: UILabel!
    @IBOutlet var iconView: UIImageView!
    @IBOutlet var activeIndicator: UIImageView!
    
    func hideActiveIndicator(_ hidden: Bool) {
        activeIndicator.isHidden = hidden
    }
    
    override var isSelected: Bool {
        didSet {
            if let mode = mode {
                if isSelected {
                    self.iconView.image = mode.onIcon
                } else {
                    self.iconView.image = mode.offIcon
                }
            }
        }
    }
}
