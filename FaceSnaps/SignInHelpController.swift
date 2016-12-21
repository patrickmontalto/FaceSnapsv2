//
//  SignInHelpController.swift
//  FaceSnaps
//
//  Created by Patrick Montalto on 12/14/16.
//  Copyright © 2016 Patrick Montalto. All rights reserved.
//

import UIKit

class SignInHelpController: UIViewController {
    
    // Gradient
    lazy var gradient: CAGradientLayer = {
        return FaceSnapsGradient(parentView: self.view)
    }()
    
    lazy var animator: GradientLayerAnimator = {
        return GradientLayerAnimator(layer: self.gradient)
    }()

    // Lock icon
    // Trouble logging in?
    lazy var troubleLoggingInLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.text = "Trouble logging in?"
        label.font = .boldSystemFont(ofSize: 16.0)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    lazy var helpDescriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "Enter your username and we'll send you a link to get back into your account."
        label.font = .systemFont(ofSize: 14.0)
        label.textColor = .white
        label.textAlignment = .center
        
        return label
    }()
    // Enter yur username or email and we'll send you a link to get back into your account...
    // Username textfield
    // Send Login Link button
    // OR Log in With Facebook button
    lazy var facebookLoginStackView: FacebookLoginStackView = {
        return FacebookLoginStackView(verticalSpacing: 24)
    }()
    // Back to Log In Button view
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.layer.addSublayer(gradient)
    }
    
    // Add animation to gradient
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        animator.animateGradient()
    }
    
}
