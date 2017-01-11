//
//  AppNavigationController.swift
//  FaceSnaps
//
//  Created by Patrick on 1/11/17.
//  Copyright © 2017 Patrick Montalto. All rights reserved.
//

import UIKit

class AppNavigationController: UINavigationController {
    convenience init() {
        self.init()
        let tabBarController = AppTabBarController()
        setViewControllers([tabBarController], animated: false)
    }
}
