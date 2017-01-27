//
//  LikesViewCell.swift
//  FaceSnaps
//
//  Created by Patrick on 1/17/17.
//  Copyright © 2017 Patrick Montalto. All rights reserved.
//

import UIKit
import IGListKit

class LikesViewCell: UICollectionViewCell, FeedItemSubSectionCell {
    
    static let height: CGFloat = 42
    
    var delegate: FeedItemSectionDelegate?
    
    private lazy var likesCount: UIButton = {
        let button = UIButton()
        let imageSize = CGSize(width: 11, height: 10)
        let heartImage = UIImage(named: "ios-heart")?.with(size: imageSize)
        
        button.titleLabel?.font = .boldSystemFont(ofSize: 14.0)
        button.setTitleColor(.black, for: .normal)
        button.setImage(heartImage, for: .normal)
        
        button.titleEdgeInsets = UIEdgeInsetsMake(0, 6.0, 0, -6.0)
        
        button.addTarget(self, action: #selector(likesCountPressed(sender:)), for: .touchUpInside)
        
        button.tintColor = .black
                
        return button
    }()
    
    func setLikesCount(count: Int) {
        let countString = count == 1 ? "1 like" : "\(count) likes"
        likesCount.setTitle(countString, for: .normal)
    }
    
    func likesCountPressed(sender: UIButton) {
        delegate?.didPress(button: .LikesCount)
    }
    
    override func layoutSubviews() {
        contentView.backgroundColor = .white
        
        contentView.addSubview(likesCount)
        
        likesCount.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
                likesCount.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 14),
                likesCount.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }

    
    // TODO: Complete function
    func cell(forFeedItem feedItem: FeedItem, withCollectionContext collectionContext: IGListCollectionContext, andSectionController sectionController: IGListSectionController, atIndex index: Int) -> UICollectionViewCell {
        let cell = collectionContext.dequeueReusableCell(of: LikesViewCell.self, for: sectionController, at: index)  as! LikesViewCell
        
        cell.setLikesCount(count: feedItem.likesCount)
        
        return cell
    }
}
