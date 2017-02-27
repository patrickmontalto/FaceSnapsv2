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
        return delegate?.userForCell()
    }
    
    @IBOutlet var userIconView: UIImageView!
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var fullnameLabel: UILabel!
    @IBOutlet var followButton: UIButton!
    
    @IBAction func followUser(_ sender: Any) {
        guard let user = user, let delegate = delegate else { return }
        
        let action: FollowAction = user.isFollowing ? .unfollow : .follow
        
        delegate.didTapFollow(action: action)
    }
    
    func configure(withDelegate delegate: UserFollowDelegate) {
        self.delegate = delegate
        
        guard let user = user else { return }
        
        userIconView.image = user.photo
        usernameLabel.text = user.userName
        fullnameLabel.text = user.name
        
        // Configure follow button
        followButton.layer.cornerRadius = 4
        
    }
    
    func setFollowButtonText() {
        guard let user = user else { return }
        let actionText = 
    }
}

// MARK: - UserFollowDelegate

protocol UserFollowDelegate {
    
    func didTapFollow(action: FollowAction)
    
    func userForCell() -> User
}

enum FollowAction: String {
    case follow, unfollow
}
