//
//  FSFilterViewCell.swift
//  FaceSnaps
//
//  Created by Patrick on 3/20/17.
//  Copyright © 2017 Patrick Montalto. All rights reserved.
//

import UIKit

class FSFilterViewCell: UICollectionViewCell {
    
    @IBOutlet var filterTitle: UILabel!
    
    @IBOutlet var filterThumbnail: UIImageView!
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                filterTitle.font = UIFont.systemFont(ofSize: 12.0, weight: UIFontWeightMedium)
                filterTitle.textColor = .black
            } else {
                filterTitle.font = UIFont.systemFont(ofSize: 12.0, weight: UIFontWeightRegular)
                filterTitle.textColor = .gray
            }
        }
    }
}
