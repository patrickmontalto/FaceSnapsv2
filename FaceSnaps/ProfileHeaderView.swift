//
//  ProfileHeaderView.swift
//  FaceSnaps
//
//  Created by Patrick on 2/15/17.
//  Copyright © 2017 Patrick Montalto. All rights reserved.
//

import UIKit

protocol ProfileHeaderDelegate {
    func didTapEditProfile()
    func didTapFollowers()
    func didTapFollowing()
    func userForView() -> User
}

class ProfileHeaderView: UIView {
    
    var delegate: ProfileHeaderDelegate!
    var user: User!
    
    lazy var userIconView: UIImageView = {
        let imgView = UIImageView()
        return imgView
    }()
    
    lazy var postsCounterBtn: UIButton = {
        let btn = UIButton()
        btn.titleLabel?.numberOfLines = 2
        let titleText = "posts"
        let count = "\(33)" //user.posts.count
        var attributedText = NSMutableAttributedString(string: "\(count) \(titleText)")
        let countRange = NSRange(location: 0, length: count.characters.count)
        let titleRange = NSRange(location: count.characters.count + 1, length: titleText.characters.count)
        attributedText.addAttributes([NSFontAttributeName: UIFont.boldSystemFont(ofSize: 16.0), NSForegroundColorAttributeName: UIColor.black], range: countRange)
        attributedText.addAttributes([NSFontAttributeName: UIFont.systemFont(ofSize: 12.0), NSForegroundColorAttributeName: UIColor.gray], range: titleRange)
        
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
//    lazy var postsCounter: UILabel = { return self.headerCounter() }()
//    lazy var postsCounterLabel: UILabel = { return self.headerLabel(withText: "posts") }()
    
    lazy var followersCounterBtn: UIButton = {
        let btn = UIButton()
        let followersCounter = self.headerCounter(property: 100)
        let followersCounterLabel = self.headerLabel(withText: "followers")
        btn.addSubview(followersCounter)
        btn.addSubview(followersCounterLabel)
        btn.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            followersCounter.topAnchor.constraint(equalTo: btn.topAnchor),
            followersCounter.centerXAnchor.constraint(equalTo: btn.centerXAnchor),
            followersCounterLabel.topAnchor.constraint(equalTo: followersCounter.bottomAnchor),
            followersCounterLabel.centerXAnchor.constraint(equalTo: btn.centerXAnchor),
        ])
        return btn
    }()
    
//    lazy var followersCounter: UILabel = { return self.headerCounter() }()
//    lazy var followersCounterLabel: UILabel = { return self.headerLabel(withText: "followers") }()
    
//    lazy var followingCounter: UILabel = { return self.headerCounter() }()
//    lazy var followingCounterLabel: UILabel = { return self.headerLabel(withText: "following") }()
    
    lazy var followingCounterBtn: UIButton = {
        let btn = UIButton()
        let followingCounter = self.headerCounter(property: 57)
        let followingCounterLabel = self.headerLabel(withText: "following")
        btn.addSubview(followingCounter)
        btn.addSubview(followingCounterLabel)
        btn.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            followingCounter.topAnchor.constraint(equalTo: btn.topAnchor),
            followingCounter.centerXAnchor.constraint(equalTo: btn.centerXAnchor),
            followingCounterLabel.topAnchor.constraint(equalTo: followingCounter.bottomAnchor),
            followingCounterLabel.centerXAnchor.constraint(equalTo: btn.centerXAnchor),
            ])
        return btn
    }()
    
    lazy var editProfileButton: UIButton = {
        let btn = UIButton()
        btn.setTitleColor(.black, for: .normal)
        btn.layer.borderColor =  UIColor.gray.cgColor
        btn.setTitle("Edit Profile", for: .normal)
        return btn
    }()
    
    lazy var userNameLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = self.user.name
        lbl.textColor = .black
        lbl.font = .boldSystemFont(ofSize: 14.0)
        return lbl
    }()
    
    // TODO: Add bio property to Users
    lazy var bioLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = .systemFont(ofSize: 14.0)
        lbl.text = "User bio here..."
        return lbl
    }()
    
    lazy var segmentedController: UISegmentedControl = {
        return UISegmentedControl()
    }()
    
    convenience init(delegate: ProfileHeaderDelegate) {
        self.init()
        self.delegate = delegate
        user = delegate.userForView()
        
        addSubview(userIconView)
        addSubview(postsCounterBtn)
        addSubview(followersCounterBtn)
        addSubview(followingCounterBtn)
        addSubview(editProfileButton)
        
        translatesAutoresizingMaskIntoConstraints = false
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        NSLayoutConstraint.activate([
            userIconView.topAnchor.constraint(equalTo: self.topAnchor, constant: 12),
            userIconView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 12),
            userIconView.widthAnchor.constraint(equalToConstant: 56),
            userIconView.heightAnchor.constraint(equalToConstant: 56),
            postsCounterBtn.topAnchor.constraint(equalTo: userIconView.topAnchor),
            postsCounterBtn.leftAnchor.constraint(equalTo: editProfileButton.leftAnchor, constant: 24),
            followersCounterBtn.topAnchor.constraint(equalTo: userIconView.topAnchor),
            followersCounterBtn.centerXAnchor.constraint(equalTo: editProfileButton.centerXAnchor),
            followingCounterBtn.rightAnchor.constraint(equalTo: editProfileButton.rightAnchor, constant: -24),
            followingCounterBtn.topAnchor.constraint(equalTo: userIconView.topAnchor),
            editProfileButton.leftAnchor.constraint(equalTo: userIconView.rightAnchor, constant: 24),
            editProfileButton.heightAnchor.constraint(equalToConstant: 32),
            editProfileButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -12),
        
        ])
        
    }
    
    private func headerCounter(property: Int) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = .systemFont(ofSize: 16.0, weight: UIFontWeightMedium)
        label.text = "\(property)"
        label.textAlignment = .center
        return label
    }
    private func headerLabel(withText text: String) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .gray
        label.font = .systemFont(ofSize: 12.0)
        label.text = text
        label.textAlignment = .center
        return label
    }
    
}
