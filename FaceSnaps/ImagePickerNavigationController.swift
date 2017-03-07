//
//  ImagePickerNavigationController.swift
//  FaceSnaps
//
//  Created by Patrick on 3/7/17.
//  Copyright © 2017 Patrick Montalto. All rights reserved.
//

import UIKit

class ImagePickerNavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let cameraTabBarController = CameraTabBarController(parentController: self)
        setViewControllers([cameraTabBarController], animated: false)
    }
}
