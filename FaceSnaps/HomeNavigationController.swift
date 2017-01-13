//
//  HomeNavigationController.swift
//  FaceSnaps
//
//  Created by Patrick on 1/11/17.
//  Copyright © 2017 Patrick Montalto. All rights reserved.
//

import UIKit

class HomeNavigationController: UINavigationController {
    override func viewDidLoad() {
        // Set root controller as home controller
        let vc = HomeController()
        setViewControllers([vc], animated: false)
        
        // Set FaceSnaps logo in center
        // TODO: Set this as black logo instead of white
        let image = UIImage(named: "facesnaps-black-nav")!
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 108, height: 30))
        imageView.center.x = view.center.x
        imageView.center.y = navigationBar.center.y + 18
        imageView.contentMode = .scaleAspectFit
        imageView.image = image
        view.addSubview(imageView)
        
        self.navigationBar.tintColor = .black
    }
    
    // TODO: Go to messages inbox
    func presentMessages() {
        // TODO: May not implement messages in this app. Too much work.
    }
}
