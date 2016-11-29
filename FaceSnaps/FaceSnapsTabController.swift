//
//  FaceSnapsTabController.swift
//  FaceSnaps
//
//  Created by Patrick Montalto on 11/29/16.
//  Copyright © 2016 Patrick Montalto. All rights reserved.
//

import UIKit

class FaceSnapsTabController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let item1 = HomeController()
        let icon1 = UITabBarItem(title: nil, image: UIImage(named: "ios-home-outline"), selectedImage: UIImage(named: "ios-home"))
        item1.tabBarItem = icon1
        viewControllers = [item1]
    }
    
    // Delegate methods
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        return true
    }
}
