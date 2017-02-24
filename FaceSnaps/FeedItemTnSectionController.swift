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
        let cell = collectionContext!.dequeueReusableCell(of: ImageCell.self, for: self, at: index) as! ImageCell
        // TODO: Add tap delegate
        // cell.setImage(image: feedItem.photo!)
        return cell
    }
    
    func didUpdate(to object: Any) {
        feedItem = object as? FeedItem
    }
    
    func didSelectItem(at index: Int) {}

}
