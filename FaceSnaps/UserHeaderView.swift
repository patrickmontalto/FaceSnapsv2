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
    
    var framesAreSet = false
    
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
        button.contentHorizontalAlignment = .left
        button.titleLabel?.textAlignment = .left
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(.gray, for: .highlighted)
        return button
    }()
    
    let locationButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = .systemFont(ofSize: 12.0)
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0.01, bottom: 0.01, right: 0)
        button.contentHorizontalAlignment = .left
        button.titleLabel?.textAlignment = .left
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(.gray, for: .highlighted)
        button.isHidden = true
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(userIcon)
        contentView.addSubview(nameButton)
        contentView.addSubview(locationButton)
        contentView.backgroundColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    var nameButtonYAnchor: NSLayoutConstraint!
    
    override func updateConstraints() {
        if let location = self.post.location {
            locationButton.isHidden = false
            locationButton.isEnabled = true
            locationButton.setTitle(location.name, for: .normal)
            nameButtonYAnchor.constant = 0
        } else {
            locationButton.isHidden = true
            locationButton.isEnabled = false
            nameButtonYAnchor.constant = 8
        }
        super.updateConstraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Being reused:
        if framesAreSet {
            return
        }
        userIcon.translatesAutoresizingMaskIntoConstraints = false
        nameButton.translatesAutoresizingMaskIntoConstraints = false
        locationButton.translatesAutoresizingMaskIntoConstraints = false
        
        nameButtonYAnchor = nameButton.topAnchor.constraint(equalTo: userIcon.topAnchor, constant: 0)

        NSLayoutConstraint.activate([
            userIcon.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 12),
            userIcon.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            userIcon.heightAnchor.constraint(equalToConstant: 32.0),
            userIcon.widthAnchor.constraint(equalToConstant: 32.0),
            locationButton.bottomAnchor.constraint(equalTo: userIcon.bottomAnchor, constant: 0),
            locationButton.leftAnchor.constraint(equalTo: nameButton.leftAnchor, constant: 0),
            locationButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -8),
            nameButton.leftAnchor.constraint(equalTo: userIcon.rightAnchor, constant: 8),
            nameButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -8),
            nameButtonYAnchor
            
        ])
        
        framesAreSet = true
    }
    
    func handleUserTap() {
        delegate?.didPressUserButton(forUser: post.user!)
    }
    func handleLocationTap() {
        delegate?.didPressLocationButton(location: post.location!)
    }
    
    private func setupViews() {
        let userName = post.user?.userName ?? "Username"
        nameButton.setTitle(userName, for: .normal)
        userIcon.image = post.user?.photo?.circle ?? UIImage()
        nameButton.addTarget(self, action: #selector(handleUserTap), for: .touchUpInside)
        if let location = post.location {
            locationButton.addTarget(self, action: #selector(handleLocationTap), for: .touchUpInside)
        }
    }
    
    func cell(forFeedItem feedItem: FeedItem, withCollectionContext collectionContext: IGListCollectionContext, andSectionController sectionController: IGListSectionController, atIndex index: Int) -> UICollectionViewCell {
        let cell = collectionContext.dequeueReusableCell(of: UserHeaderView.self, for: sectionController, at: index) as! UserHeaderView
        cell.post = feedItem
        cell.delegate = (sectionController as! FeedItemSectionController).feedItemSectionDelegate
        cell.layoutSubviews()
        cell.updateConstraints()
        return cell
    }
}
