//
//  CommentCell.swift
//  FaceSnaps
//
//  Created by Patrick on 1/23/17.
//  Copyright © 2017 Patrick Montalto. All rights reserved.
//

import UIKit
import IGListKit

class CommentCell: UICollectionViewCell, FeedItemSubSectionCell {
    
    static func cellHeight(forComment comment: Comment) -> CGFloat {
        let author = comment.author!.userName
        let text = comment.text
        let labelHeight = TextSize.height(author + text, width: UIScreen.main.bounds.width - 24, attributes: [ NSFontAttributeName: UIFont.systemFont(ofSize: 14.0)])
        
        return labelHeight + 8
    }
    
    var delegate: FeedItemSectionDelegate?
    
    private var contentLabel: InteractableLabel = {
        return InteractableLabel()
    }()
    
    lazy var authorTap: UITapGestureRecognizer = {
        return UITapGestureRecognizer(target: self, action: #selector(handleTapOnLabel(tapGesture:)))
    }()
    
    func setContentLabel(_ comment: Comment) {
        
        // Get author and caption strings
        let author = comment.author!.userName
        let text = comment.text
        
        // Set contentLabel to interactable label with author and caption
        self.contentLabel = InteractableLabel(type: .comment, boldText: author, nonBoldText: text)
        
        self.contentLabel.numberOfLines = 2
        
        self.contentLabel.addGestureRecognizer(self.authorTap)
    }
    
    func handleTapOnLabel(tapGesture: UITapGestureRecognizer) {
        if tapGesture.didTapAttributedTextInLabel(label: contentLabel, inRange: contentLabel.boldRange) {
            delegate?.didPress(button: .AuthorName)
        }
    }
    
    
    override func layoutSubviews() {
        contentView.backgroundColor = .white
        backgroundColor = .white
        
        contentView.addSubview(contentLabel)
        
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            contentLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            contentLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            //            contentView.bottomAnchor.constraint(equalTo: contentLabel.bottomAnchor, constant: 12),
            contentView.heightAnchor.constraint(equalToConstant: frame.height),
            contentView.trailingAnchor.constraint(equalTo: contentLabel.trailingAnchor, constant: 12),
            ])
    }
    
    override func prepareForReuse() {
        self.contentLabel = InteractableLabel()
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
        
        cell.setContentLabel(comment)
        
        return cell
    }
}
