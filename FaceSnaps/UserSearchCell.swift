//
//  UserSearchCell.swift
//  FaceSnaps
//
//  Created by Patrick on 2/15/17.
//  Copyright © 2017 Patrick Montalto. All rights reserved.
//

import UIKit

class UserSearchCell: UITableViewCell {
    
    var user: User! {
        didSet {
            setContentForUser()
        }
    }
    
    @IBOutlet var userIconView: UIImageView!
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var fullnameLabel: UILabel!
    
    
    func setContentForUser() {
        userIconView.image = user.photo?.circle
        usernameLabel.text = user.userName
        if user.isFollowing {
            fullnameLabel.text = user.name + " \u{2022} Following"
        } else {
            fullnameLabel.text = user.name
        }
    }
    
}
