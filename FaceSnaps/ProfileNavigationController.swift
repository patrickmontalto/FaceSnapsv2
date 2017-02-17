//
//  ProfileNavigationController.swift
//  FaceSnaps
//
//  Created by Patrick on 1/11/17.
//  Copyright © 2017 Patrick Montalto. All rights reserved.
//

import UIKit

class ProfileNavigationController: UINavigationController {
    var user: User!
    
    init(user: User) {
        super.init(nibName: nil, bundle: nil)
        self.user = user
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        let profileController = ProfileController()
        profileController.user = user
        setViewControllers([profileController], animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
}
