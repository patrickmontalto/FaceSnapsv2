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
    
    // TODO: Complete implementation
    func cell(forFeedItem feedItem: FeedItem, withCollectionContext collectionContext: IGListCollectionContext, andSectionController sectionController: IGListSectionController, atIndex index: Int) -> UICollectionViewCell {
        let cell = collectionContext.dequeueReusableCell(of: UICollectionViewCell.self, for: sectionController, at: index)
        
        return cell
    }
}
