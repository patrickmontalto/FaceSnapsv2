//
//  LoginFlowNavigationController.swift
//  FaceSnaps
//
//  Created by Patrick Montalto on 12/21/16.
//  Copyright © 2016 Patrick Montalto. All rights reserved.
//

import UIKit

class LoginFlowNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBarHidden(true, animated: false)
        
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        navigationBar.isTranslucent = true
        navigationBar.shadowImage = UIImage()
        navigationBar.tintColor = .white
    }
    
}
