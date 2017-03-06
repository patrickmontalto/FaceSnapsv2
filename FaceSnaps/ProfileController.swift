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
        
        // Hide FaceSnaps logo
        (navigationController as? HomeNavigationController)?.logoIsHidden = true

        view.addSubview(collectionView)
        
        collectionView.register(ProfileHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "profileHeaderView")
        collectionView.register(ImageCell.self, forCellWithReuseIdentifier: "imageCell")
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        // Add notification if current user updates profile
        NotificationCenter.default.addObserver(self, selector: #selector(updateViewForUpdatedUser), name: .userProfileUpdatedNotification, object: nil)
     
        if user.isCurrentUser {
            // On current user profile. Make right Nav bar action the settings
            let optionsButton = UIBarButtonItem(image: UIImage(named: "cog")!, style: .plain, target: self, action: #selector(pushUserOptionsView))
            optionsButton.tintColor = .black
            navigationItem.rightBarButtonItem = optionsButton

        }
        
        // Get posts for user
        FaceSnapsClient.sharedInstance.getUserPosts(user: user) { (data, error) in
            if let data = data {
                self.posts = Array(data)
                self.collectionView.reloadData()
            } else {
                _ = APIErrorHandler.handle(error: error!, logError: true)
            }
        }
        
        // Observe when the user profile is changed
        NotificationCenter.default.addObserver(self, selector: #selector(updateUser), name: Notification.Name.userProfileUpdatedNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = user.userName
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        title = nil
    }
    
    func updateUser() {
        FaceSnapsClient.sharedInstance.refreshUser(user) { (error) in
            let indexSet: IndexSet = [0]
            self.collectionView.reloadSections(indexSet)
        }
    }
    
    func pushUserOptionsView() {
        let vc = UserOptionsViewController()
        vc.user = user
        navigationController?.pushViewController(vc, animated: true)
    }
    
    /// This function should be called after a change to the user is sent to the API.
    /// Changes include an email, username, or photo change.
    func updateViewForUpdatedUser() {
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
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
    
    // Present the individual post selected
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let post = posts[indexPath.row]
        let vc = PostsCollectionViewContainer(style: .feed, dataSource: .individualPost(postId: post.pk))
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - ProfileHeaderDelegate
extension ProfileController: ProfileHeaderDelegate {
    
    func userForView() -> User {
        return user
    }
    
    func didTapFollowers() {
        // TODO: Present list of followers
        FaceSnapsClient.sharedInstance.getFollowedByForUser(user: user) { (users, error) in
            guard let users = users else { return }
            let vc = UsersListViewController()
            vc.users = users
            vc.title = "Followers"
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func didTapFollowing() {
        // TODO: Present list of following\
        FaceSnapsClient.sharedInstance.getFollowingForUser(user: user) { (users, error) in
            guard let users = users else { return }
            let vc = UsersListViewController()
            vc.users = users
            vc.title = "Following"
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func didTapEditProfile() {
        // Present the edit view controller for the current user
        let editProfileVC = EditProfileViewController()
        navigationController?.pushViewController(editProfileVC, animated: true)
    }
    
    func didTapFollow(action: FollowAction) {
        // Make request to either follow or unfollow
        FaceSnapsClient.sharedInstance.modifyRelationship(action: action, user: user) { (result, error) in
            guard let result = result else {
                return
            }
            // Update status for user
            self.user.incomingStatus = result.rawValue
            
            // Update button
            let cell = self.collectionView.supplementaryView(forElementKind: UICollectionElementKindSectionHeader, at: IndexPath(row: 0, section: 0)) as! ProfileHeaderView
            cell.setFollowButton()
            
            // Post notification to reload current user in app
            NotificationCenter.default.post(name: Notification.Name.userProfileUpdatedNotification, object: nil)
        }

    }
}
