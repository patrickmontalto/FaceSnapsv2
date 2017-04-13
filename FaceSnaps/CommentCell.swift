//
//  CommentCell.swift
//  FaceSnaps
//
//  Created by Patrick on 1/23/17.
//  Copyright © 2017 Patrick Montalto. All rights reserved.
//

import UIKit
import IGListKit
import ActiveLabel

class CommentCell: UICollectionViewCell, FeedItemSubSectionCell {
    
    static func cellHeight(forComment comment: Comment) -> CGFloat {
        let author = comment.author!.userName
        let text = comment.text
        let labelHeight = TextSize.height(author + text, width: UIScreen.main.bounds.width - 30, attributes: [ NSFontAttributeName: UIFont.systemFont(ofSize: 14.0)])
        
        return min(labelHeight + 8, 25.0)
    }
    
    var delegate: CommentDelegate?
    
    var comment: Comment! {
        didSet {
            setContentLabel(self.comment)
        }
    }
    
    private var contentLabel: ActiveLabel = {
        return ActiveLabel()
    }()

    
    private func setContentLabel(_ comment: Comment) {
        
        // Get author and caption strings
        let author = comment.author!
        let text = comment.text
        
        // Set contentLabel to interactable label with author and caption
        contentLabel = ActiveLabel.commentLabel(author: author, caption: text, delegate: delegate!)
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        contentLabel.numberOfLines = 2
    }
    
    
    override func layoutSubviews() {
        contentView.backgroundColor = .white
        backgroundColor = .white
        
        contentView.addSubview(contentLabel)
        
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            contentLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            contentLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            contentLabel.heightAnchor.constraint(equalToConstant: frame.height),
            //            contentView.bottomAnchor.constraint(equalTo: contentLabel.bottomAnchor, constant: 12),
            contentView.heightAnchor.constraint(equalToConstant: frame.height),
            contentView.trailingAnchor.constraint(equalTo: contentLabel.trailingAnchor, constant: 12),
            ])
    }
    
    override func prepareForReuse() {
        self.contentLabel = ActiveLabel()
        for view in contentView.subviews {
            view.removeFromSuperview()
        }
        super.prepareForReuse()
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        setNeedsLayout()
        layoutIfNeeded()
        let size = contentView.systemLayoutSizeFitting(layoutAttributes.size)
        var newFrame = layoutAttributes.frame
        // note: don't change the width
        newFrame.size.height = ceil(size.height)
        layoutAttributes.frame = newFrame
        return layoutAttributes
    }

    
    func cell(forFeedItem feedItem: FeedItem, withCollectionContext collectionContext: IGListCollectionContext, andSectionController sectionController: IGListSectionController, atIndex index: Int) -> UICollectionViewCell {
        let cell = collectionContext.dequeueReusableCell(of: CommentCell.self, for: sectionController, at: index) as! CommentCell
        
        cell.delegate = (sectionController as! FeedItemSectionController).commentDelegate

        
        let commentIndex = FeedItemSubsection.commentIndex(feedItem)
        
        var comment = Comment()
        
        switch index {
        case 5:
            comment = feedItem.comments[commentIndex]
        case 6:
            comment = feedItem.comments[commentIndex - 1]
        case 7:
            comment = feedItem.comments[commentIndex - 2]
        default:
            break
        }
        
        cell.comment = comment
    
        return cell
    }
}
