//
//  UserHeaderView.swift
//  FaceSnaps
//
//  Created by Patrick on 1/16/17.
//  Copyright © 2017 Patrick Montalto. All rights reserved.
//

import UIKit
import IGListKit

final class UserHeaderView: UICollectionViewCell, FeedItemSubSectionCell {
    
    //fileprivate static let insets = UIEdgeInsets(top: 8, left: 36, bottom: 8, right: 15)
    
    let userIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 14.0)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(userIcon)
        contentView.addSubview(nameLabel)
        contentView.backgroundColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        userIcon.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        //let bounds = contentView.bounds
        //nameLabel.frame = UIEdgeInsetsInsetRect(bounds, UserHeaderView.insets)
        NSLayoutConstraint.activate([
            userIcon.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 8),
            userIcon.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            userIcon.heightAnchor.constraint(equalToConstant: 32.0),
            userIcon.widthAnchor.constraint(equalToConstant: 32.0),
            nameLabel.leftAnchor.constraint(equalTo: userIcon.rightAnchor, constant: 8),
            nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            nameLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor)
        ])
    }
    
    // TODO: Add locationLabel
    
    func cell(forFeedItem feedItem: FeedItem, withCollectionContext collectionContext: IGListCollectionContext, andSectionController sectionController: IGListSectionController, atIndex index: Int) -> UICollectionViewCell {
        
            let cell = collectionContext.dequeueReusableCell(of: UserHeaderView.self, for: sectionController, at: index) as! UserHeaderView
            
            cell.nameLabel.text = feedItem.user?.userName ?? ""
            cell.userIcon.image = feedItem.user?.photo?.circle ?? UIImage()
        
            return cell
    }
}
