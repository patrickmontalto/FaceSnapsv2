//
//  HomeNavigationController.swift
//  FaceSnaps
//
//  Created by Patrick on 1/11/17.
//  Copyright © 2017 Patrick Montalto. All rights reserved.
//

import UIKit

class HomeNavigationController: UINavigationController {
    
    lazy var facesnapsLogoView: UIImageView = {
        let image = UIImage(named: "facesnaps-black-nav")!
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 108, height: 30))
        imageView.center.x = self.view.center.x
        imageView.center.y = self.navigationBar.center.y + 18
        imageView.contentMode = .scaleAspectFit
        imageView.image = image
        
        return imageView
    }()
    
    override func viewDidLoad() {
        // Set root controller as home controller
        let vc = HomeController()
        setViewControllers([vc], animated: false)
        
        // Set FaceSnaps logo in center
        view.addSubview(facesnapsLogoView)
        
        self.navigationBar.tintColor = .black
        self.logoIsHidden = false
    }
    
    // TODO: Go to messages inbox
    func presentMessages() {
        // TODO: May not implement messages in this app. Too much work.
    }
    
    var logoIsHidden: Bool! {
        didSet {
            facesnapsLogoView.isHidden = logoIsHidden
        }
    }
}
