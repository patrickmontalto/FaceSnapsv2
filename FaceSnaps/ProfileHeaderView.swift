//
//  ProfileHeaderView.swift
//  FaceSnaps
//
//  Created by Patrick on 2/15/17.
//  Copyright © 2017 Patrick Montalto. All rights reserved.
//

import UIKit

class ProfileHeaderView: UIView {
    
    var containingView: ProfileController!
    
    lazy var userIconView: UIImageView = {
        let imgView = UIImageView()
        return imgView
    }()
    
    lazy var postsCounter: UILabel = { return self.headerCounter() }()
    lazy var postsCounterLabel: UILabel = { return self.headerLabel(withText: "posts") }()
    
    lazy var followersCounter: UILabel = { return self.headerCounter() }()
    lazy var followersCounterLabel: UILabel = { return self.headerLabel(withText: "followers") }()
    
    lazy var followingCounter: UILabel = { return self.headerCounter() }()
    lazy var followingCounterLabel: UILabel = { return self.headerLabel(withText: "following") }()
    
    lazy var segmentedController: UISegmentedControl = {
        return UISegmentedControl()
    }()
    
    convenience init(containingView: ProfileController) {
        self.init()
        self.containingView = containingView
        
        addSubview(postsCounter)
        addSubview(postsCounterLabel)
        addSubview(followersCounter)
        addSubview(followersCounterLabel)
        addSubview(followingCounter)
        addSubview(followingCounterLabel)
        
        NSLayoutConstraint.activate([
            
        ])
    }
    
    private func headerCounter() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = .systemFont(ofSize: 16.0, weight: UIFontWeightMedium)
        label.text = "0"
        return label
    }
    private func headerLabel(withText text: String) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .gray
        label.font = .systemFont(ofSize: 12.0)
        label.text = text
        return label
    }
}
