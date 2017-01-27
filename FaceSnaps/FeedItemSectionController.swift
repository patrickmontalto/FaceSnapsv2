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
            return CGSize(width: collectionContext.containerSize.width, height: UserHeaderView.height)
        case .image:
            return CGSize(width: collectionContext.containerSize.width, height: collectionContext.containerSize.width)
        case .controls:
            return CGSize(width: collectionContext.containerSize.width, height: ControlsCell.height)
        case .likes:
            return CGSize(width: collectionContext.containerSize.width, height: LikesViewCell.height)
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
        // TODO: Insets for sections?
        //inset = UIEdgeInsets(top: -64, left: 0, bottom: 0, right: 0)
        
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

// MARK: - ControlsCellDelegate
extension FeedItemSectionController: FeedItemSectionDelegate {
    
    func didPress(button: FeedItemButtonType) {
        // TODO: Switch on button type and do appropriate action
        
        
    }
    
    func didPressCommentButton() {
        //TODO:  Present the comments screen for the post
    }
    
    func didPressLikeButton() {
        // TODO: Configure
        // Does the user currently like the post?
        // What action needs to be taken.
        // POST a like or an unlike on the current post as the current user
        // Ensure that the correct heart icon is set and that the like count increases or decreases by 1
    }
}
