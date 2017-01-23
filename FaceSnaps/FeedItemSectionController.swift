//
//  FeedItemSectionController.swift
//  FaceSnaps
//
//  Created by Patrick on 1/16/17.
//  Copyright © 2017 Patrick Montalto. All rights reserved.
//

import UIKit
import IGListKit

enum FeedItemSubsection: Int {
    case header, image, controls, likes, caption, comments
    
    func sizeForItem(withCollectionContext collectionContext: IGListCollectionContext) -> CGSize {
        switch self {
        case .header:
            return CGSize(width: collectionContext.containerSize.width, height: 55)
        case .image:
            return CGSize(width: collectionContext.containerSize.width, height: collectionContext.containerSize.width)
        case .controls:
            return CGSize(width: collectionContext.containerSize.width, height: 55)
        case .likes:
            return CGSize(width: collectionContext.containerSize.width, height: 32)
        case .caption:
            return CGSize.zero
        case .comments:
            return CGSize.zero
        }
    }
    
    func cellForSection() -> FeedItemSubSectionCell {
        switch self {
        case .header:
            return UserHeaderView()
        case .image:
            return ImageCell()
        case .controls:
            return ControlsCell()
        case .likes:
            return LikesViewCell()
        case .caption:
            return CaptionCell()
        case .comments:
            return CommentsViewCell()
        }
    }
}

final class FeedItemSectionController: IGListSectionController, IGListSectionType {
    
    var feedItem: FeedItem!
    
    override init() {
        super.init()
        //supplementaryViewSource = self
    }
    
    // MARK: IGlistSectionType
    func numberOfItems() -> Int {
        return 5 + min(feedItem.comments.count, 3)
    }
    
    func sizeForItem(at index: Int) -> CGSize {
        return FeedItemSubsection(rawValue: index)!.sizeForItem(withCollectionContext: collectionContext!)
    }
    
    func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let sectionType = FeedItemSubsection(rawValue: index) else { return UICollectionViewCell() }
        let cell = sectionType.cellForSection().cell(forFeedItem: feedItem, withCollectionContext: collectionContext!, andSectionController: self, atIndex: index)
        
        return cell
    }
    
    func didUpdate(to object: Any) {
        feedItem = object as? FeedItem
    }
    
    func didSelectItem(at index: Int) {}
    
//    // MARK: IGListSupplementaryViewSource
//    func supportedElementKinds() -> [String] {
//        return [UICollectionElementKindSectionHeader]
//    }
//    
//    func viewForSupplementaryElement(ofKind elementKind: String, at index: Int) -> UICollectionReusableView {
//        let view = collectionContext?.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader,
//                                                                       for: self,
//                                                                       nibName: "UserHeaderView",
//                                                                       bundle: nil,
//                                                                       at: index) as! UserHeaderView
//        view.nameLabel.text = feedItem.user.name
//        return view
//    }
//    
//    func sizeForSupplementaryView(ofKind elementKind: String, at index: Int) -> CGSize {
//        return CGSize(width: collectionContext!.containerSize.width, height: 40)
//    }
//    
}
