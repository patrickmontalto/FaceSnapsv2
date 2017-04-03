//
//  CaptionCell.swift
//  FaceSnaps
//
//  Created by Patrick on 1/23/17.
//  Copyright © 2017 Patrick Montalto. All rights reserved.
//

import UIKit
import IGListKit
import ActiveLabel

class CaptionCell: UICollectionViewCell, FeedItemSubSectionCell {
    
    static func cellHeight(forFeedItem feedItem: FeedItem) -> CGFloat {
        let author = feedItem.user!.userName
        let caption = feedItem.caption
        let labelHeight = TextSize.height(author + caption, width: UIScreen.main.bounds.width - 24, attributes: [ NSFontAttributeName: UIFont.systemFont(ofSize: 14.0)])
        
        return labelHeight + 8
    }
    // MARK: - Properties
    var post: FeedItem! {
        didSet {
            setContentLabel()
        }
    }
    
    var delegate: CommentDelegate?
    
    private var contentLabel: ActiveLabel = {
        return ActiveLabel()
    }()
    
    func setContentLabel() {
        
        // Get author and caption strings
        let author = post.user!
        let caption = post.caption
    
        // Set contentLabel to interactable label with author and caption
        contentLabel = ActiveLabel.captionLabel(author: author, caption: caption, delegate: delegate!)
    }
    
    // MARK: - UICollectionViewCell
    override func layoutSubviews() {
        contentView.backgroundColor = .white
        backgroundColor = .white
        
        contentView.addSubview(contentLabel)
        
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            contentLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            contentLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
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
        let cell = collectionContext.dequeueReusableCell(of: CaptionCell.self, for: sectionController, at: index) as! CaptionCell
        
        cell.delegate = (sectionController as! FeedItemSectionController).commentDelegate
        
        cell.post = feedItem
        
        return cell
    }
}
