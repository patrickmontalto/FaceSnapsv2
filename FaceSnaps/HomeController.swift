//
//  HomeController.swift
//  FaceSnaps
//
//  Created by Patrick Montalto on 11/29/16.
//  Copyright © 2016 Patrick Montalto. All rights reserved.
//

import UIKit

class HomeController: UIViewController {
    
    lazy var initLoadFeedIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        view.hidesWhenStopped = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeFeed()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        view.addSubview(initLoadFeedIndicator)
        
        NSLayoutConstraint.activate([
                initLoadFeedIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                initLoadFeedIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func initializeFeed() {
        // Start animating
        initLoadFeedIndicator.startAnimating()
        
        FaceSnapsClient.sharedInstance.getUserFeed { (success, errors) in
            // Stop animating
            self.initLoadFeedIndicator.stopAnimating()
            
            if success {
                print("Got user feed!")
            } else {
                print("Couldn't get feed")
            }
        }
    }
}
