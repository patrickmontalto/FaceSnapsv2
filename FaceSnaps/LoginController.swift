//
//  LoginController.swift
//  FaceSnaps
//
//  Created by Patrick Montalto on 11/29/16.
//  Copyright © 2016 Patrick Montalto. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    lazy var gradient: CAGradientLayer = {
        return FaceSnapsGradient(parentView: self.view)
    }()
    
    lazy var animator: GradientLayerAnimator = {
        return GradientLayerAnimator(layer: self.gradient)
    }()


    lazy var loginStackView: LoginStackView = {
        return LoginStackView(parentView: self)
    }()

    
    lazy var facebookLoginStackView: FacebookLoginStackView = {
        return FacebookLoginStackView(verticalSpacing: self.verticalSpacing)
    }()
    
    lazy var signUpView: LoginBottomView = {
        return LoginBottomView(labelType: .signUp)
    }()
    
    lazy var verticalSpacing: CGFloat = {
        return 24
    }()
    
    lazy var getHelpTap: UITapGestureRecognizer = {
        return UITapGestureRecognizer(target: self, action: #selector(LoginViewController.handleTapOnLabel(tapGesture:)))
    }()
    
    lazy var signUpTap: UITapGestureRecognizer = {
        return UITapGestureRecognizer(target: self, action: #selector(LoginViewController.handleTapOnLabel(tapGesture:)))
    }()
    
    private var fbLoginStackViewTopConstraint: NSLayoutConstraint!
    
    // Add animation to gradient
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        animator.animateGradient()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        super.hideKeyboardWhenTappedAround()
        self.loginStackView.usernameTextField.addTarget(self, action: #selector(LoginViewController.textFieldEmptyCheck(sender:)), for: .editingChanged)
        self.loginStackView.passwordTextField.addTarget(self, action: #selector(LoginViewController.textFieldEmptyCheck(sender:)), for: .editingChanged)
                
        self.view.layer.addSublayer(gradient)
        
        configureTapRecognizer()
        
        addKeyboardObservers(showSelector: #selector(LoginViewController.keyboardWillShow(sender:)), hideSelector: #selector(LoginViewController.keyboardWillHide(sender:)))
        
        // Configure constraint for stackView position
        fbLoginStackViewTopConstraint = NSLayoutConstraint(item: facebookLoginStackView, attribute: .top, relatedBy: .equal, toItem: loginStackView, attribute: .bottom, multiplier: 1.0, constant: verticalSpacing)
        
        loginStackView.setLoginButtonTarget(target: self, action: #selector(LoginViewController.loginButtonPressed(sender:)))
    }
    
    override func viewWillLayoutSubviews() {
        view.addSubview(loginStackView)
        view.addSubview(facebookLoginStackView)
        view.addSubview(signUpView)
        
        loginStackView.translatesAutoresizingMaskIntoConstraints = false
        facebookLoginStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            loginStackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 35),
            loginStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 64),
            loginStackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -35),
            facebookLoginStackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 35),
            facebookLoginStackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -35),
            fbLoginStackViewTopConstraint,
            signUpView.leftAnchor.constraint(equalTo: view.leftAnchor),
            signUpView.rightAnchor.constraint(equalTo: view.rightAnchor),
            signUpView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        removeKeyboardObservers()
    }
    
    func configureTapRecognizer() {
        loginStackView.getHelpLabel.addGestureRecognizer(getHelpTap)
        signUpView.interactableLabel.addGestureRecognizer(signUpTap)
    }
    
    // TODO: Configure login button pressed
    func loginButtonPressed(sender: UIButton) {
        
    }
    
    // TODO: Present view controllers for each action tapped
    func handleTapOnLabel(tapGesture: UITapGestureRecognizer) {
        var label = InteractableLabel()
        
        if tapGesture == getHelpTap {
            label = loginStackView.getHelpLabel
        } else if tapGesture == signUpTap {
            label = signUpView.interactableLabel
        }
        
        let didTapLink = tapGesture.didTapAttributedTextInLabel(label: label, inRange: label.boldRange)
        
        if didTapLink {
            print("Tapped!")
        }
    }

    // MARK: - Keyboard Notifications
    func keyboardWillShow(sender: NSNotification) {
        fbLoginStackViewTopConstraint.constant = 10
        facebookLoginStackView.spacing = 10
        view.layoutIfNeeded()
    }
    
    func keyboardWillHide(sender: NSNotification) {
        fbLoginStackViewTopConstraint.constant = 24
        facebookLoginStackView.spacing = 24
        view.layoutSubviews()
    }
    
    
}

// UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {
    
    // Return key to dismiss keyboarrd
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == loginStackView.usernameTextField {
            loginStackView.passwordTextField.becomeFirstResponder()
        } else if textField == loginStackView.passwordTextField {
            loginStackView.loginButton.sendActions(for: .touchUpInside)
        }
        // view.endEditing(true)
        return false
    }
    
    // Disable/enable login button if text fields are empty/filled in
    func textFieldEmptyCheck(sender: UITextField) {
        if loginStackView.usernameEmpty || loginStackView.passwordEmpty {
            loginStackView.setLoginButton(enabled: false)
        } else {
            loginStackView.setLoginButton(enabled: true)
        }
    }
}





