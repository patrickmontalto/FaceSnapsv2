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
        guard let item = FeedItemSubsection(rawValue: index) else { return CGSize.zero }
        guard let collectionContext = collectionContext else { return CGSize.zero }
        
        switch item {
        case .header:
            return CGSize(width: collectionContext.containerSize.width, height: UserHeaderView.height)
        case .image:
            return CGSize(width: collectionContext.containerSize.width, height: collectionContext.containerSize.width)
        case .controls:
            return CGSize(width: collectionContext.containerSize.width, height: ControlsCell.height)
        case .likes:
            return CGSize(width: collectionContext.containerSize.width, height: LikesViewCell.height)
        case .caption:
            return CGSize(width: collectionContext.containerSize.width, height: CaptionCell.cellHeight(forFeedItem: feedItem))
        case .comments:
            return CGSize.zero
        }
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
    
}

// MARK: - ControlsCellDelegate
extension FeedItemSectionController: FeedItemSectionDelegate {
    
    func didPress(button: FeedItemButtonType) {
        // TODO: Switch on button type and do appropriate action
        
        
    }
    
    func didPressUserButton(forUser user: User) {
        // Present user controller
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
