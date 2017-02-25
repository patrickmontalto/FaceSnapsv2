//
//  FeedItemThumbnailSectionController.swift
//  FaceSnaps
//
//  Created by Patrick on 2/24/17.
//  Copyright © 2017 Patrick Montalto. All rights reserved.
//

import UIKit
import IGListKit

final class FeedItemThumbnailSectionController: IGListSectionController, IGListSectionType {
    
    var feedItem: FeedItem!
    var parentViewController: UIViewController!
    
    convenience init(parentViewController: UIViewController) {
        self.init()
        self.parentViewController = parentViewController
    }
    

    func sizeForItem(at index: Int) -> CGSize {
        let width = (collectionContext!.containerSize.width - 2)/3
        return CGSize(width: width, height: width)
    }
    
    func numberOfItems() -> Int {
        return 1
    }

    
    func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = collectionContext!.dequeueReusableCell(of: ImageCell.self, for: self, at: index) as! ImageCell
        cell.setImage(image: feedItem.photo!)
        return cell

    }
    
    func didUpdate(to object: Any) {
        feedItem = object as? FeedItem
    }
    
    func didSelectItem(at index: Int) {
        let vc = PostsCollectionViewContainer(style: .feed, dataSource: .individualPost(postId: feedItem.pk))
        parentViewController.navigationController?.pushViewController(vc, animated: true)
    }
    
}


