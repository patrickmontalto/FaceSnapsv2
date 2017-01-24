//
//  UserHeaderView.swift
//  FaceSnaps
//
//  Created by Patrick on 1/16/17.
//  Copyright © 2017 Patrick Montalto. All rights reserved.
//

import UIKit
import IGListKit

final class UserHeaderView: UICollectionViewCell, FeedItemSubSectionCell {
    
    fileprivate static let insets = UIEdgeInsets(top: 8, left: 15, bottom: 8, right: 15)
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 14.0)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(nameLabel)
        contentView.backgroundColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let bounds = contentView.bounds
        nameLabel.frame = UIEdgeInsetsInsetRect(bounds, UserHeaderView.insets)
    }
    
    // TODO: Add locationLabel
    
    func cell(forFeedItem feedItem: FeedItem, withCollectionContext collectionContext: IGListCollectionContext, andSectionController sectionController: IGListSectionController, atIndex index: Int) -> UICollectionViewCell {
        
            let cell = collectionContext.dequeueReusableCell(of: UserHeaderView.self, for: sectionController, at: index) as! UserHeaderView
            
            cell.nameLabel.text = feedItem.user?.userName ?? ""
            
            return cell
    }
}
