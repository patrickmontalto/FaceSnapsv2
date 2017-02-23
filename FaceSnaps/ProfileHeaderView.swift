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

class ProfileHeaderView: UICollectionReusableView {
    
    var delegate: ProfileHeaderDelegate!
    var user: User!
    
    lazy var userIconView: UIImageView = {
        let imgView = UIImageView()
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.image = self.user.photo?.circle ?? UIImage()
        return imgView
    }()
    
    lazy var postsCounterBtn: UIButton = {
        let btn = UIButton()
        let postsCounter = self.headerCounter(property: self.user.postsCount)
        let postsCounterLabel = self.headerLabel(withText: "posts")
        btn.addSubview(postsCounter)
        btn.addSubview(postsCounterLabel)
        btn.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            postsCounter.topAnchor.constraint(equalTo: btn.topAnchor),
            postsCounter.centerXAnchor.constraint(equalTo: btn.centerXAnchor),
            postsCounterLabel.topAnchor.constraint(equalTo: postsCounter.bottomAnchor),
            postsCounterLabel.centerXAnchor.constraint(equalTo: btn.centerXAnchor),
            ])
        return btn
    }()
    
    lazy var followersCounterBtn: UIButton = {
        let btn = UIButton()
        let followersCounter = self.headerCounter(property: self.user.followersCount)
        let followersCounterLabel = self.headerLabel(withText: "followers")
        btn.addSubview(followersCounter)
        btn.addSubview(followersCounterLabel)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(didTapFollowers), for: .touchUpInside)

        
        NSLayoutConstraint.activate([
            followersCounter.topAnchor.constraint(equalTo: btn.topAnchor),
            followersCounter.centerXAnchor.constraint(equalTo: btn.centerXAnchor),
            followersCounterLabel.topAnchor.constraint(equalTo: followersCounter.bottomAnchor),
            followersCounterLabel.centerXAnchor.constraint(equalTo: btn.centerXAnchor),
        ])
        return btn
    }()
    
    lazy var followingCounterBtn: UIButton = {
        let btn = UIButton()
        let followingCounter = self.headerCounter(property: self.user.followingCount)
        let followingCounterLabel = self.headerLabel(withText: "following")
        btn.addSubview(followingCounter)
        btn.addSubview(followingCounterLabel)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(didTapFollowing), for: .touchUpInside)
        
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
        btn.layer.borderColor =  UIColor.lightGray.cgColor
        btn.layer.borderWidth = 1
        btn.layer.cornerRadius = 4
        btn.setTitle("Edit Profile", for: .normal)
        btn.titleLabel?.font = .boldSystemFont(ofSize: 14.0)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(didTapEditProfile), for: .touchUpInside)
        return btn
    }()
    
    lazy var userNameLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = self.user.name
        lbl.textColor = .black
        lbl.font = .boldSystemFont(ofSize: 14.0)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    // TODO: Add bio property to Users
    lazy var bioLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = .systemFont(ofSize: 14.0)
        lbl.text = "User bio here..."
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    func prepareCell(withDelegate delegate: ProfileHeaderDelegate) {
        self.delegate = delegate
        user = delegate.userForView()
        
        addSubview(userIconView)
        addSubview(postsCounterBtn)
        addSubview(followersCounterBtn)
        addSubview(followingCounterBtn)
        addSubview(editProfileButton)
        addSubview(userNameLabel)
    }
    
    func updateUser() {
        userIconView.image = user.photo?.circle
        userNameLabel.text = user.name
    }
    
    func didTapEditProfile() {
        delegate.didTapEditProfile()
    }
    
    func didTapFollowers() {
        delegate.didTapFollowers()
    }
    
    func didTapFollowing() {
        delegate.didTapFollowing()
    }
    

    override func layoutSubviews() {
        super.layoutSubviews()
        NSLayoutConstraint.activate([
            userIconView.topAnchor.constraint(equalTo: self.topAnchor, constant: 12),
            userIconView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 12),
            userIconView.widthAnchor.constraint(equalToConstant: 72),
            userIconView.heightAnchor.constraint(equalToConstant: 72),
            postsCounterBtn.topAnchor.constraint(equalTo: userIconView.topAnchor),
            postsCounterBtn.leftAnchor.constraint(equalTo: editProfileButton.leftAnchor, constant: 24),
            followersCounterBtn.topAnchor.constraint(equalTo: userIconView.topAnchor),
            followersCounterBtn.centerXAnchor.constraint(equalTo: editProfileButton.centerXAnchor),
            followingCounterBtn.rightAnchor.constraint(equalTo: editProfileButton.rightAnchor, constant: -24),
            followingCounterBtn.topAnchor.constraint(equalTo: userIconView.topAnchor),
            editProfileButton.leftAnchor.constraint(equalTo: userIconView.rightAnchor, constant: 24),
            editProfileButton.heightAnchor.constraint(equalToConstant: 24),
            editProfileButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -12),
            editProfileButton.topAnchor.constraint(equalTo: postsCounterBtn.bottomAnchor, constant: 12),
            userNameLabel.topAnchor.constraint(equalTo: userIconView.bottomAnchor, constant: 16),
            userNameLabel.leftAnchor.constraint(equalTo: userIconView.leftAnchor),
        
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
