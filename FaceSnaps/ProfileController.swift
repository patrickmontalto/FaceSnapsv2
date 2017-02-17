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

    var posts: [FeedItem]?
    
    lazy var collectionView: UICollectionView = {
        let cvLayout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: cvLayout)
        cvLayout.headerReferenceSize = CGSize(width: self.view.frame.width, height: 150)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = .white
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        posts =  // user.posts.count
        title = user.userName
        
        view.addSubview(collectionView)
        
        collectionView.register(ProfileHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "profileHeaderView")
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        if FaceSnapsDataSource.sharedInstance.currentUser! == user {
            // On current user profile. Make right Nav bar action the settings
            // TODO: Get gear symbol for options and elipses for actions
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Options", style: .plain, target: self, action: #selector(pushUserOptionsView))
        }
        
        // TODO: Get posts for user
    }
    
    func pushUserOptionsView() {
        // TODO: Push user options view
    }
    
    // TODO: profileHeaderView is a header to the entire collectionView
    // CollectionView will have 3 cells per row
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor),
        ])
    
    }
}

// MARK: - CollectionView data & delegate
extension ProfileController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0 // return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "profileHeaderView", for: indexPath) as! ProfileHeaderView
        
        cell.prepareCell(withDelegate: self)
    
        cell.frame.size.height = 150
        
        return cell
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
