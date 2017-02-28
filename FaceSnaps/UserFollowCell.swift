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
        guard let outgoingStatus = FollowResult(rawValue: user.outgoingStatus) else { return }
        
        var actionText = ""
        var backgroundColor = UIColor.clear
        var borderColor = UIColor.clear
        var textColor = UIColor.white
        
        switch outgoingStatus {
        case .follows:
            actionText = "Follow"
            let buttonBlue = UIColor(red: 82/255.0, green: 149/255.0, blue: 253/255.0, alpha: 1.0)
            backgroundColor = buttonBlue
            borderColor = buttonBlue
        case .none:
            actionText = "Following"
            backgroundColor = .white
            borderColor = .lightGray
            textColor = .black
        case .requested:
            actionText = "Requested"
            backgroundColor = .white
            borderColor = .lightGray
            textColor = .black
        }

        followButton.setTitle(actionText, for: .normal)
        followButton.setTitleColor(textColor, for: .normal)
        followButton.backgroundColor = backgroundColor
        followButton.layer.borderColor = borderColor.cgColor
        followButton.layer.borderWidth = 0.5
        
    }
}

// MARK: - UserFollowDelegate

protocol UserFollowDelegate {
    
    func didTapFollow(action: FollowAction, withCell cell: UserFollowCell)
    
    func userForCell(_ cell: UserFollowCell) -> User?
}
