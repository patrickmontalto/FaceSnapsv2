//
//  AppTabBarController.swift
//  FaceSnaps
//
//  Created by Patrick on 1/11/17.
//  Copyright © 2017 Patrick Montalto. All rights reserved.
//

import UIKit

class AppTabBarController: UITabBarController , UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        UITabBar.appearance().tintColor = .black
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Home view controller
        let homeTab = HomeNavigationController()
        let homeImage = UIImage(named: "ios-home-outline")!
        let homeImageSelected = UIImage(named: "ios-home")!
        let homeTabBarItem = UITabBarItem(title: nil, image: homeImage, selectedImage: homeImageSelected)
        homeTabBarItem.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
        homeTab.tabBarItem = homeTabBarItem
        
        // Search view controller
        let searchTab = SearchNavigationController()
        let searchImage = UIImage(named: "ios-search")!
        let searchImageSelected = UIImage(named: "ios-search-strong")!
        let searchTabBarItem = UITabBarItem(title: nil, image: searchImage, selectedImage: searchImageSelected)
        searchTabBarItem.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
        searchTab.tabBarItem = searchTabBarItem
        
        // Camera view controller
        let cameraTab = CameraTabBarController()
        let cameraImage = UIImage(named: "camera-launch")!
        let cameraImageSelected = UIImage(named: "camera-selected")!
        let cameraTabBarItem = UITabBarItem(title: nil, image: cameraImage, selectedImage: cameraImageSelected)
        cameraTabBarItem.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
        cameraTab.tabBarItem = cameraTabBarItem
        
        // Likes view controller
        let likesTab = LikesNavigationController()
        let likeImage = UIImage(named: "ios-heart-outline")!
        let likeImageSelected = UIImage(named: "ios-heart")!
        let likesTabBarItem = UITabBarItem(title: nil, image: likeImage, selectedImage: likeImageSelected)
        likesTabBarItem.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
        likesTab.tabBarItem = likesTabBarItem
        
        // Profile view controller
        let profileTab = ProfileNavigationController()
        let profileImage = UIImage(named: "ios-person-outline")
        let profileImageSelected = UIImage(named: "ios-person")
        let profileTabBarItem = UITabBarItem(title: nil, image: profileImage, selectedImage: profileImageSelected)
        profileTabBarItem.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
        profileTab.tabBarItem = profileTabBarItem
        
        // Set VCs
        self.viewControllers = [homeTab, searchTab, cameraTab, likesTab, profileTab]
    }
    
    // MARK: - UITabBarControllerDelegate 
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        // Selected view controller
        print("selected \(viewController)")
    }
    
}
