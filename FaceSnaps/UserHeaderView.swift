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
    
    static let height: CGFloat = 48
    
    var post: FeedItem! {
        didSet {
            setupViews()
        }
    }
    
    var delegate: FeedItemSectionDelegate?
    
    let userIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let nameButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = .boldSystemFont(ofSize: 14.0)
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0.01, bottom: 0.01, right: 0)
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(.gray, for: .highlighted)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(userIcon)
        contentView.addSubview(nameButton)
        contentView.backgroundColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        userIcon.translatesAutoresizingMaskIntoConstraints = false
        nameButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            userIcon.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 12),
            userIcon.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            userIcon.heightAnchor.constraint(equalToConstant: 32.0),
            userIcon.widthAnchor.constraint(equalToConstant: 32.0),
            nameButton.leftAnchor.constraint(equalTo: userIcon.rightAnchor, constant: 8),
            nameButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
    
    func handleUserTap() {
        delegate?.didPressUserButton(forUser: post.user!)
    }
    
    // TODO: Add locationLabel
    
    private func setupViews() {
        let userName = post.user?.userName ?? "Username"
        nameButton.setTitle(userName, for: .normal)
        userIcon.image = post.user?.photo?.circle ?? UIImage()
        nameButton.addTarget(self, action: #selector(handleUserTap), for: .touchUpInside)

        // TODO: Add location
    }
    
    func cell(forFeedItem feedItem: FeedItem, withCollectionContext collectionContext: IGListCollectionContext, andSectionController sectionController: IGListSectionController, atIndex index: Int) -> UICollectionViewCell {
        
        let cell = collectionContext.dequeueReusableCell(of: UserHeaderView.self, for: sectionController, at: index) as! UserHeaderView
        cell.post = feedItem
    
        return cell
    }
}
