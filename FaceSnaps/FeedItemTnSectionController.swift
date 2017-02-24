//
//  FeedItemTnSectionController.swift
//  FaceSnaps
//
//  Created by Patrick on 2/24/17.
//  Copyright © 2017 Patrick Montalto. All rights reserved.
//

import UIKit
import IGListKit

protocol FeedItemThumbnailDelegate {
    func didTapItem(item: FeedItem)
}

final class FeedItemTnSectionController: IGListSectionController {
    
    var feedItem: FeedItem!
    
    var delegate: FeedItemThumbnailDelegate!
    
    convenience init(delegate: FeedItemThumbnailDelegate) {
        self.init()
        self.delegate = delegate
    }
    // MARK: IGlistSectionType
    func numberOfItems() -> Int {
        return 1
    }

    func cellForItem(at index: Int) -> UICollectionViewCell {
        // TODO: ImageCell that is 1/3 width of the screen
//        guard let sectionType = FeedItemSubsection(rawValue: index) else { return UICollectionViewCell() }
//        if feedItem.comments.count > 3 && index == FeedItemSubsection.comment1.rawValue {
//            let cell = collectionContext!.dequeueReusableCell(of: ViewAllCommentsCell.self, for: self, at: index) as! ViewAllCommentsCell
//            cell.delegate = feedItemSectionDelegate
//            cell.post = feedItem
//            
//            return cell
//        } else {
//            let cell = sectionType.cellForSection().cell(forFeedItem: feedItem, withCollectionContext: collectionContext!, andSectionController: self, atIndex: index)
//            
//            return cell
//        }
    }
    
    func didUpdate(to object: Any) {
        feedItem = object as? FeedItem
    }
    
    func didSelectItem(at index: Int) {}
    
}
