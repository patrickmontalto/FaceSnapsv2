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
    
    lazy var loginStackViewTopDistance: CGFloat = {
        switch UIDevice.current.deviceType {
        case .iPhone35in:
            return 48
        case .iPhone40in:
            return 64
        case .iPhone47in, .iPhone55in:
            return 100
        default: break
        }
        return 64
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
    
    // MARK: White status bar text
    override var preferredStatusBarStyle: UIStatusBarStyle {
        get {
            return UIStatusBarStyle.lightContent
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.hideKeyboardWhenTappedAround()
        self.loginStackView.usernameTextField.addTarget(self, action: #selector(LoginViewController.textFieldEmptyCheck(sender:)), for: .editingChanged)
        self.loginStackView.passwordTextField.addTarget(self, action: #selector(LoginViewController.textFieldEmptyCheck(sender:)), for: .editingChanged)
                
        self.view.layer.addSublayer(gradient)
        
        configureTapRecognizers()
        
        addKeyboardObservers(showSelector: #selector(LoginViewController.keyboardWillShow(sender:)), hideSelector: #selector(LoginViewController.keyboardWillHide(sender:)))
        
        // Configure constraint for stackView position
        fbLoginStackViewTopConstraint = NSLayoutConstraint(item: facebookLoginStackView, attribute: .top, relatedBy: .equal, toItem: loginStackView, attribute: .bottom, multiplier: 1.0, constant: verticalSpacing)
        
        loginStackView.setLoginButtonTarget(target: self, action: #selector(LoginViewController.loginButtonPressed(sender:)))
    }
    
    // MARK: Add animation to gradient
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        animator.animateGradient()
    }
    
    override func viewWillLayoutSubviews() {
        view.addSubview(loginStackView)
        view.addSubview(facebookLoginStackView)
        view.addSubview(signUpView)
        
        loginStackView.translatesAutoresizingMaskIntoConstraints = false
        facebookLoginStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            loginStackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 36),
            loginStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: loginStackViewTopDistance),
            loginStackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -36),
            facebookLoginStackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 36),
            facebookLoginStackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -36),
            fbLoginStackViewTopConstraint,
            signUpView.leftAnchor.constraint(equalTo: view.leftAnchor),
            signUpView.rightAnchor.constraint(equalTo: view.rightAnchor),
            signUpView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        removeKeyboardObservers()
    }
    
    func configureTapRecognizers() {
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
            if tapGesture.didTapAttributedTextInLabel(label: label, inRange: label.boldRange) {
                let vc = SignInHelpController()
                navigationController?.pushViewController(vc, animated: true)
            }
        } else if tapGesture == signUpTap {
            label = signUpView.interactableLabel
            if tapGesture.didTapAttributedTextInLabel(label: label, inRange: label.boldRange) {
                // TODO: Present Sign Up VC
            }
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





