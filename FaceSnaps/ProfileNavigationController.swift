//
//  ProfileNavigationController.swift
//  FaceSnaps
//
//  Created by Patrick on 1/11/17.
//  Copyright © 2017 Patrick Montalto. All rights reserved.
//

import UIKit

class ProfileNavigationController: UINavigationController {
    override func viewDidLoad() {
        let profileController = ProfileController()
        setViewControllers([profileController], animated: false)
    }
}
