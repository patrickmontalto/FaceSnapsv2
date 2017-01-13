//
//  LikesNavigationController.swift
//  FaceSnaps
//
//  Created by Patrick Montalto on 1/12/17.
//  Copyright © 2017 Patrick Montalto. All rights reserved.
//

import UIKit

class LikesNavigationController: UINavigationController {
    override func viewDidLoad() {
        // Set root controller as home controller
        let vc = LikesController()
        setViewControllers([vc], animated: false)
        
        self.navigationBar.tintColor = .black
    }
}
