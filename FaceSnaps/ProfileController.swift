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

    var posts = [FeedItem]()
    
    lazy var collectionView: UICollectionView = {
        let cvLayout = UICollectionViewFlowLayout()
        cvLayout.minimumLineSpacing = 1
        cvLayout.minimumInteritemSpacing = 1
        let itemWidth = (self.view.frame.width - 2)/3
        cvLayout.itemSize = CGSize(width: itemWidth, height: itemWidth)
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
        
        view.addSubview(collectionView)
        
        collectionView.register(ProfileHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "profileHeaderView")
        collectionView.register(ImageCell.self, forCellWithReuseIdentifier: "imageCell")
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        // Add notification if current user updates profile
        NotificationCenter.default.addObserver(self, selector: #selector(updateViewForUpdatedUser), name: .userProfileUpdatedNotification, object: nil)
     
        if FaceSnapsDataSource.sharedInstance.currentUser! == user {
            // On current user profile. Make right Nav bar action the settings
            // TODO: Get gear symbol for options and elipses for actions
            let optionsButton = UIBarButtonItem(image: UIImage(named: "cog")!, style: .plain, target: self, action: #selector(pushUserOptionsView))
            optionsButton.tintColor = .black
            navigationItem.rightBarButtonItem = optionsButton

        }
        
        // TODO: Get posts for user
        FaceSnapsClient.sharedInstance.getUserPosts(user: user) { (data, error) in
            if let data = data {
                print(data.count)
                self.posts = Array(data)
                self.collectionView.reloadData()
            } else {
                _ = APIErrorHandler.handle(error: error!, logError: true)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = user.userName
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        title = nil
    }
    
    func pushUserOptionsView() {
        let vc = UserOptionsViewController()
        vc.user = user
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func updateViewForUpdatedUser() {
        let cell = collectionView.supplementaryView(forElementKind: UICollectionElementKindSectionHeader, at: IndexPath(row: 0, section: 0)) as! ProfileHeaderView
        cell.updateUser()
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
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let post = posts[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! ImageCell
        if let photo = post.photo {
            cell.setImage(image: photo)
        } else {
            // TODO: Set placeholder Image
            cell.setImage(image: UIImage())
            let caching = true
            // Begin background process to download image from URL
            // Cache if necessary
            FaceSnapsDataSource.sharedInstance.photoFromURL(for: post, cache: caching, completionHandler: { (image) in
                DispatchQueue.main.async {
                    cell.setImage(image: image)
                }
            })
            
        }

        return cell
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
        // TODO: Present list of followers
    }
    
    func didTapFollowing() {
        // TODO: Present list of following
    }
    
    func didTapEditProfile() {
        // TODO: Present edit profile view
        let editProfileVC = EditProfileViewController()
        navigationController?.pushViewController(editProfileVC, animated: true)
    }
}
