//
//  ControlsCell.swift
//  FaceSnaps
//
//  Created by Patrick on 1/23/17.
//  Copyright © 2017 Patrick Montalto. All rights reserved.
//

import UIKit
import IGListKit

class ControlsCell: UICollectionViewCell, FeedItemSubSectionCell {
    
    static let height: CGFloat = 46
    
    var post: FeedItem!
    
    var sectionController: FeedItemSectionController!
    
    var delegate: FeedItemSectionDelegate?
    
    private lazy var likeButton: UIButton = {
        let btn = UIButton()
        btn.addTarget(self, action: #selector(likeButtonPressed), for: .touchUpInside)
        return btn
    }()
    
    private lazy var commentButton: UIButton = {
        let btn = UIButton()
        let commentImage = UIImage(named: "ios-chatbubble-outline")!
        btn.setImage(commentImage, for: .normal)
        btn.addTarget(self, action: #selector(commentButtonPressed), for: .touchUpInside)
        return btn
    }()
    
    let divider: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = .gray
        return lineView
    }()
    
    override func layoutSubviews() {
        contentView.backgroundColor = .white
        
        contentView.addSubview(divider)
        contentView.addSubview(likeButton)
        contentView.addSubview(commentButton)
        
        divider.translatesAutoresizingMaskIntoConstraints = false
        commentButton.translatesAutoresizingMaskIntoConstraints = false
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
                likeButton.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 12),
                likeButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                likeButton.heightAnchor.constraint(equalToConstant: 21),
                likeButton.widthAnchor.constraint(equalToConstant: 24),
                commentButton.leftAnchor.constraint(equalTo: likeButton.rightAnchor, constant: 18),
                commentButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                divider.heightAnchor.constraint(equalToConstant: 0.5),
                divider.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 12),
                divider.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -12),
                divider.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    // MARK: - Handling button presses
    
    func likeButtonPressed() {
        delegate?.didPressLikeButton(forPost: post, inSectionController: sectionController, withButton: likeButton)
    }
    
    func commentButtonPressed() {
        delegate?.didPressCommentButton(forPost: post)
    }
    
    func setLikeButtonImage(liked: Bool) {
        if liked {
            let image = UIImage(named: "ios-heart-red")!
            likeButton.setImage(image, for: .normal)
        } else {
            let image = UIImage(named: "ios-heart-outline")!
            likeButton.setImage(image, for: .normal)
        }
    }
    
    // TODO: Complete implementation
    func cell(forFeedItem feedItem: FeedItem, withCollectionContext collectionContext: IGListCollectionContext, andSectionController sectionController: IGListSectionController, atIndex index: Int) -> UICollectionViewCell {
        let cell = collectionContext.dequeueReusableCell(of: ControlsCell.self, for: sectionController, at: index) as! ControlsCell
        
        
        cell.delegate = (sectionController as! FeedItemSectionController).feedItemSectionDelegate
        
        cell.setLikeButtonImage(liked: feedItem.liked)
        cell.post = feedItem
        cell.sectionController = sectionController as! FeedItemSectionController
        
        return cell
    }
}
