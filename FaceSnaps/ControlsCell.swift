//
//  ControlsCell.swift
//  FaceSnaps
//
//  Created by Patrick on 1/23/17.
//  Copyright © 2017 Patrick Montalto. All rights reserved.
//

import UIKit
import IGListKit

class ControlsCell: UICollectionViewCell, FeedItemSubSectionCell {
    
    let likeButton: UIButton = {
        let btn = UIButton()
        
        return btn
    }()
    
    let commentButton: UIButton = {
        let btn = UIButton()
        return btn
    }()
    
    let divider: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = .gray
        return lineView
    }()
    
    override func layoutSubviews() {
        contentView.backgroundColor = .white
        
        contentView.addSubview(divider)
        
        divider.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
                divider.heightAnchor.constraint(equalToConstant: 1),
                divider.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 8),
                divider.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -8),
                divider.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    // TODO: Complete implementation
    func cell(forFeedItem feedItem: FeedItem, withCollectionContext collectionContext: IGListCollectionContext, andSectionController sectionController: IGListSectionController, atIndex index: Int) -> UICollectionViewCell {
        let cell = collectionContext.dequeueReusableCell(of: ControlsCell.self, for: sectionController, at: index) as! ControlsCell
        
        return cell
    }
}
