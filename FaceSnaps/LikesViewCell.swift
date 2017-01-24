//
//  LikesViewCell.swift
//  FaceSnaps
//
//  Created by Patrick on 1/17/17.
//  Copyright © 2017 Patrick Montalto. All rights reserved.
//

import UIKit
import IGListKit

class LikesViewCell: UICollectionViewCell, FeedItemSubSectionCell {
    
    
    // TODO: Complete function
    func cell(forFeedItem feedItem: FeedItem, withCollectionContext collectionContext: IGListCollectionContext, andSectionController sectionController: IGListSectionController, atIndex index: Int) -> UICollectionViewCell {
        let cell = collectionContext.dequeueReusableCell(of: UICollectionViewCell.self, for: sectionController, at: index) 
        
        return cell
    }
}
