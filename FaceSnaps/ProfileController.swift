//
//  ProfileController.swift
//  FaceSnaps
//
//  Created by Patrick on 1/11/17.
//  Copyright © 2017 Patrick Montalto. All rights reserved.
//

import UIKit

class ProfileController: UIViewController {
    
    var user: User!

    var profileHeaderView: ProfileHeaderView!
    
    var posts: [FeedItem]?
    
    lazy var collectionView: UICollectionView = {
        let cvLayout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: cvLayout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.delegate = self
        cv.dataSource = self
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileHeaderView = ProfileHeaderView(delegate: self)
//        posts =  // user.posts.count
        view.addSubview(profileHeaderView)
        view.addSubview(collectionView)
    
    
    }
    
    // TODO: profileHeaderView is a header to the entire collectionView
    // CollectionView will have 3 cells per row
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        NSLayoutConstraint.activate([
                profileHeaderView.heightAnchor.constraint(equalToConstant: 256),
                profileHeaderView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor),
                profileHeaderView.leftAnchor.constraint(equalTo: view.leftAnchor),
                profileHeaderView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    
    }
}

// MARK: - CollectionView data & delegate
extension ProfileController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12 // return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        return UIView() as! UICollectionReusableView
    }
}

// MARK: - ProfileHeaderDelegate
extension ProfileController: ProfileHeaderDelegate {
    
    func userForView() -> User {
        return user
    }
    
    func didTapFollowers() {
        
    }
    
    func didTapFollowing() {
        
    }
    
    func didTapEditProfile() {
        
    }
}
