//
//  UsernameSignUpController.swift
//  FaceSnaps
//
//  Created by Patrick on 1/6/17.
//  Copyright © 2017 Patrick Montalto. All rights reserved.
//

import UIKit

class UsernameSignUpController: UIViewController {
    
    // TODO: "Create Username"
    lazy var pageTitle: UILabel = {
        let label = UILabel()

        return label
    }()
    
    // TODO: Add a username or use our own suggestion. You can change this at any time.
    lazy var formDirections: UILabel = {
        let label = UILabel()
        
        return label
    }()
    
    // TODO: When text entry stops, query API to see if available
    // TODO: Put checkmark in TF when available
    // TODO: Put reload button to randomly generate a new username (fullname + 4 random numbers)
    lazy var usernameTextField: LoginTextField = {
        let textField = LoginTextField()
        
        return textField
    }()
    
    // TODO: Repeat code here, needs to be made into a class
    lazy var nextButton: UIButton = {
        let button = UIButton()
        
        return button
    }()
    
    // TODO: Add target to button submit to API and sign in
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    
}
