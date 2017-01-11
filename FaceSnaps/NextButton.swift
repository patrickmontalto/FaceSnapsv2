//
//  NextButton.swift
//  FaceSnaps
//
//  Created by Patrick Montalto on 1/7/17.
//  Copyright © 2017 Patrick Montalto. All rights reserved.
//

import UIKit

class NextButton: UIButton {
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(activityIndicatorStyle: .white)
        view.hidesWhenStopped = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        self.layer.cornerRadius = 4
        self.setTitle("Next", for: .normal)
        self.titleLabel?.font = .systemFont(ofSize: 14.0)
        self.setBackgroundColor(color: UIColor(red: 157/255, green: 204/255, blue: 245/255, alpha: 1.0), forUIControlState: .disabled)
        self.setBackgroundColor(color: UIColor(red: 62/255, green: 153/255, blue: 237/255, alpha: 1.0), forUIControlState: .normal)
        self.setTitleColor(.white, for: .normal)
        self.layer.masksToBounds = true
        
        self.isEnabled = false
        
        self.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }
    
    // TODO: Repeat code from LoginViews.swift
    func animateLoading(_ enabled: Bool) {
        if enabled {
            // TODO: hide text
            self.setTitle("", for: .normal)
            activityIndicator.startAnimating()
        } else {
            // TODO: Show text
            self.setTitle("Next", for: .normal)
            activityIndicator.stopAnimating()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
