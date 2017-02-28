//
//  UserFollowCell.swift
//  FaceSnaps
//
//  Created by Patrick on 2/27/17.
//  Copyright © 2017 Patrick Montalto. All rights reserved.
//

import UIKit

class UserFollowCell: UITableViewCell {
    
    var delegate: UserFollowDelegate?
    var user: User? {
        guard let delegate = delegate else { return nil }
        return delegate.userForCell(self)
    }
    
    @IBOutlet var userIconView: UIImageView!
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var fullnameLabel: UILabel!
    @IBOutlet var followButton: UIButton!
    
    @IBAction func followUser(_ sender: Any) {
        guard let user = user, let delegate = delegate else { return }
        
        let action: FollowAction = user.isFollowing ? .unfollow : .follow

        delegate.didTapFollow(action: action, withCell: self)
    }
    
    func configure(withDelegate delegate: UserFollowDelegate) {
        self.delegate = delegate
        
        guard let user = user else { return }
        
        userIconView.image = user.photo
        usernameLabel.text = user.userName
        fullnameLabel.text = user.name
        
        // Configure follow button
        followButton.layer.cornerRadius = 4
        setFollowButtonText()
        
    }
    
    func setFollowButtonText() {
        guard let user = user else { return }
        let actionText = user.isFollowing ? FollowAction.unfollow.rawValue : FollowAction.follow.rawValue
        followButton.setTitle(actionText, for: .normal)
    }
}

// MARK: - UserFollowDelegate

protocol UserFollowDelegate {
    
    func didTapFollow(action: FollowAction, withCell cell: UserFollowCell)
    
    func userForCell(_ cell: UserFollowCell) -> User?
}

enum FollowAction: String {
    case follow, unfollow
}
