//
//  CommentSectionController.swift
//  FaceSnaps
//
//  Created by Patrick Montalto on 2/9/17.
//  Copyright © 2017 Patrick Montalto. All rights reserved.
//

import UIKit
import IGListKit

final class CommentSectionController: IGListSectionController, IGListSectionType {
    
    var comment: Comment!
    var commentDelegate: CommentDelegate!
    
    // Use dependency injection to inject the comment delegate
    convenience init(commentDelegate: CommentDelegate) {
        self.init()
        self.commentDelegate = commentDelegate
    }
    
    override init() {
        super.init()
        //supplementaryViewSource = self
    }
    
    // MARK: - IGListSectionType
    func numberOfItems() -> Int {
        return 1
    }
    
    func sizeForItem(at index: Int) -> CGSize {
        guard let collectionContext = collectionContext else { return CGSize.zero }
        let fullWidth = collectionContext.containerSize.width
        var height = FullCommentCell.cellHeight(forComment: comment)
        let section = collectionContext.section(for: self)
        if section == 0 { height -= 12 }
        return CGSize(width: fullWidth, height: height)
    }
    
    func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = collectionContext?.dequeueReusableCell(of: FullCommentCell.self, for: self, at: index) as! FullCommentCell
        let section = collectionContext!.section(for: self)
        cell.delegate = commentDelegate
        cell.comment = comment
        cell.isCaptionCell = (section == 0)
        
        return cell
    }
    
    func didUpdate(to object: Any) {
        comment = object as? Comment
    }
    
    func didSelectItem(at index: Int) {}
}
