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
    case header, image, controls, likes, caption, comment1, comment2, comment3
    
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
        case .comment1, .comment2, .comment3:
            return CommentCell()
        }
    }
    
    static func commentIndex(_ feedItem: FeedItem) -> Int {
        switch feedItem.comments.count {
        case 1:
            return 0
        case 2:
            return 1
        default:
            return 2
        }
    }
}

final class FeedItemSectionController: IGListSectionController, IGListSectionType {
    
    var feedItem: FeedItem!
    
    var feedItemSectionDelegate: FeedItemSectionDelegate!
    var commentDelegate: CommentDelegate!
    
    convenience init(feedItemSectionDelegate: FeedItemSectionDelegate, commentDelegate: CommentDelegate) {
        self.init()
        self.feedItemSectionDelegate = feedItemSectionDelegate
        self.commentDelegate = commentDelegate
    }
    
    
    override init() {
        super.init()
        supplementaryViewSource = self
    }
    
    // MARK: IGlistSectionType
    func numberOfItems() -> Int {
        return 5 + min(feedItem.comments.count, 3)
    }
    
    func sizeForItem(at index: Int) -> CGSize {
        guard let item = FeedItemSubsection(rawValue: index) else { return CGSize.zero }
        guard let collectionContext = collectionContext else { return CGSize.zero }
        
        let commentIndex = FeedItemSubsection.commentIndex(feedItem)
        
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
        case .comment1:
            // If there are more than 3 comments, show "View all X comments button" instead of first comment on list
            if feedItem.comments.count > 3 {
                return CGSize(width: collectionContext.containerSize.width, height: ViewAllCommentsCell.cellHeight)
            } else {
                return CGSize(width: collectionContext.containerSize.width, height: CommentCell.cellHeight(forComment: feedItem.comments[commentIndex]))
            }
        case .comment2:
            return CGSize(width: collectionContext.containerSize.width, height: CommentCell.cellHeight(forComment: feedItem.comments[commentIndex - 1]))
        case .comment3:
            return CGSize(width: collectionContext.containerSize.width, height: CommentCell.cellHeight(forComment: feedItem.comments[commentIndex - 2]))
        }
    }
    
    func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let sectionType = FeedItemSubsection(rawValue: index) else { return UICollectionViewCell() }
        if feedItem.comments.count > 3 && index == FeedItemSubsection.comment1.rawValue {
            let cell = collectionContext!.dequeueReusableCell(of: ViewAllCommentsCell.self, for: self, at: index) as! ViewAllCommentsCell
            cell.delegate = feedItemSectionDelegate
            cell.post = feedItem
            
            return cell
        } else {
            let cell = sectionType.cellForSection().cell(forFeedItem: feedItem, withCollectionContext: collectionContext!, andSectionController: self, atIndex: index)
            
            return cell
        }
    }
    
    func didUpdate(to object: Any) {
        feedItem = object as? FeedItem
    }
    
    func didSelectItem(at index: Int) {}
    
}

// MARK: IGListSupplementaryViewSource
extension FeedItemSectionController: IGListSupplementaryViewSource {
    func supportedElementKinds() -> [String] {
        return [UICollectionElementKindSectionFooter]
    }
    
    func viewForSupplementaryElement(ofKind elementKind: String, at index: Int) -> UICollectionReusableView {
        let view = collectionContext?.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, for: self, nibName: "TimeView", bundle: nil, at: index) as! TimeView
        
        view.setTimeLabel(timeCreated: feedItem.datePosted)
        
        view.frame = CGRect(x: view.frame.origin.x, y: view.frame.origin.y, width: view.frame.width, height: 22)
        
        return view
    }
    
    func sizeForSupplementaryView(ofKind elementKind: String, at index: Int) -> CGSize {
        return CGSize(width: collectionContext!.containerSize.width, height: 22.0)
    }
    

}
