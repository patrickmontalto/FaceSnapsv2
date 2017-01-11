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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Home view controller
        let homeTab = HomeNavigationController()
        let homeImage = UIImage(named: "ios-home-outline")!
        let homeImageSelected = UIImage(named: "ios-home")!
        let homeTabBarItem = UITabBarItem(title: nil, image: homeImage, selectedImage: homeImageSelected)
        
        homeTab.tabBarItem = homeTabBarItem
        // Search view controller
        
        // Camera view controller
        
        // Likes view controller
        
        // Profile view controller
        let profileTab = ProfileNavigationController()
        let profileImage = UIImage(named: "ios-person-outline")
        let profileImageSelected = UIImage(named: "ios-person")
        let profileTabBarItem = UITabBarItem(title: "Profile", image: profileImage, selectedImage: profileImageSelected)
        
        profileTab.tabBarItem = profileTabBarItem
        
        // Set VCs
        self.viewControllers = [homeTab, profileTab]
    }
    
    // MARK: - UITabBarControllerDelegate 
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        // Selected view controller
        print("selected \(viewController)")
    }
}
