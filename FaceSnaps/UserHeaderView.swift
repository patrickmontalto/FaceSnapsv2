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
    
    @IBOutlet var nameLabel: UILabel!
    
    // TODO: Add locationLabel
    
    func cell(forFeedItem feedItem: FeedItem, withCollectionContext collectionContext: IGListCollectionContext, andSectionController sectionController: IGListSectionController, atIndex index: Int) -> UICollectionViewCell {
        
            let cell = collectionContext.dequeueReusableCell(of: UserHeaderView.self, for: sectionController, at: index) as! UserHeaderView
            
            cell.nameLabel.text = feedItem.user?.userName ?? ""
            
            return cell
    }
}
