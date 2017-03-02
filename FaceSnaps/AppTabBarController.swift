//
//  AppTabBarController.swift
//  FaceSnaps
//
//  Created by Patrick on 1/11/17.
//  Copyright © 2017 Patrick Montalto. All rights reserved.
//

import UIKit

class AppTabBarController: UITabBarController , UITabBarControllerDelegate {
    
    fileprivate let imageSize = CGSize(width: 22.0, height: 22.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        UITabBar.appearance().tintColor = .black
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Home view controller
        let homeTab = HomeNavigationController()
        let homeImage = UIImage(named: "ios-home-outline")?.with(size: imageSize)
        let homeImageSelected = UIImage(named: "ios-home")?.with(size: imageSize)
        let homeTabBarItem = UITabBarItem(title: nil, image: homeImage, selectedImage: homeImageSelected)
        homeTabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        homeTab.tabBarItem = homeTabBarItem
        
        // Search view controller
        let searchTab = SearchNavigationController()
        let searchImage = UIImage(named: "ios-search")?.with(size: imageSize)
        let searchImageSelected = UIImage(named: "ios-search-strong")?.with(size: imageSize)
        let searchTabBarItem = UITabBarItem(title: nil, image: searchImage, selectedImage: searchImageSelected)
        searchTabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        searchTab.tabBarItem = searchTabBarItem
        
        // Camera view controller
        let cameraTab = CameraTabBarController()
        let cameraImage = UIImage(named: "camera-launch")?.with(size: imageSize)
        let cameraImageSelected = UIImage(named: "camera-selected")?.with(size: imageSize)
        let cameraTabBarItem = UITabBarItem(title: nil, image: cameraImage, selectedImage: cameraImageSelected)
        cameraTabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        cameraTab.tabBarItem = cameraTabBarItem
        
        // Likes view controller
        let likesTab = LikesNavigationController()
        let likeImage = UIImage(named: "ios-heart-outline")?.with(size: CGSize(width: 22, height: 17))
        let likeImageSelected = UIImage(named: "ios-heart")?.with(size: CGSize(width: 22, height: 17))
        let likesTabBarItem = UITabBarItem(title: nil, image: likeImage, selectedImage: likeImageSelected)
        likesTabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        likesTab.tabBarItem = likesTabBarItem
        
        // Profile view controller
        let profileTab = ProfileNavigationController(user: FaceSnapsDataSource.sharedInstance.currentUser!)
        let profileImage = UIImage(named: "person-outline")?.with(size: imageSize)
        let profileImageSelected = UIImage(named: "person-selected")?.with(size: imageSize)
        let profileTabBarItem = UITabBarItem(title: nil, image: profileImage, selectedImage: profileImageSelected)
        // Hide title for item
        let tabBarTitleOffset = UIOffsetMake(0, 50)
        profileTabBarItem.titlePositionAdjustment = tabBarTitleOffset
        profileTabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)

        profileTab.tabBarItem = profileTabBarItem
        
        // Set VCs
        self.viewControllers = [homeTab, searchTab, cameraTab, likesTab, profileTab]
    }
    

    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        // TODO: Make a function that takes the view controller, switches on the type, and returns the proper notification name
        // Make a notificationName for each view controller
        if viewController is HomeNavigationController && self.selectedIndex == 0 {
            NotificationCenter.default.post(name: .tappedHomeNotificationName, object: nil)
        }
        return true
    }
    // MARK: - UITabBarControllerDelegate
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
    }
    
}
