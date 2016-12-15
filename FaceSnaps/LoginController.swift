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
        var animator = GradientLayerAnimator(layer: self.gradient)
        
        return animator
    }()

    lazy var logoView: UIStackView = {
        let stackView = UIStackView()
        let imageView = UIImageView()
        imageView.image = UIImage(named: "facesnaps-logo")!
        
        stackView.alignment = .center
        stackView.axis = .vertical
        stackView.addArrangedSubview(imageView)

        return stackView
    }()
    
    lazy var usernameTextField: LoginTextField = {
        let textField = LoginTextField()
        let extraLightGray = UIColor(white: 245/255, alpha: 0.8)
        // Set white placeholder
        textField.attributedPlaceholder = NSAttributedString(string: "Username", attributes: [NSForegroundColorAttributeName: extraLightGray])
        textField.textColor = .white
        textField.delegate = self
        textField.font = .systemFont(ofSize: 14)
        
        textField.backgroundColor = UIColor.white.withAlphaComponent(0.08)
        textField.layer.cornerRadius = 4.0
        
        return textField
    }()
    
    lazy var passwordTextField: LoginTextField = {
        let textField = LoginTextField()
        let extraLightGray = UIColor(white: 245/255, alpha: 0.8)
        // Set white placeholder
        textField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSForegroundColorAttributeName: extraLightGray])
        textField.isSecureTextEntry = true
        textField.textColor = .white

        textField.delegate = self
        textField.backgroundColor = UIColor.white.withAlphaComponent(0.08)
        textField.layer.cornerRadius = 4.0

        textField.font = .systemFont(ofSize: 14)

        return textField
    }()
    
    lazy var loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Login", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 14)
        
        button.backgroundColor = .white
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(.lightGray, for: .disabled)
        button.layer.cornerRadius = 4.0
        button.isEnabled = false
        
        return button
    }()
    
    lazy var getHelpLabel: UILabel = {
        let label = UILabel()
        let text = "Forgot your login details? Get help signing in."
        let nonBoldRange = NSMakeRange(0, 26)
        let attributes = [
            NSFontAttributeName: UIFont.boldSystemFont(ofSize: 12.0),
            NSForegroundColorAttributeName: UIColor.white
        ]
        
        let nonAttributes = [
            NSFontAttributeName: UIFont.systemFont(ofSize: 12.0),
            NSForegroundColorAttributeName: UIColor.white
        ]
        
        label.attributedText = text.NSStringWithAttributes(attributes: attributes, nonAttributes: nonAttributes, nonAttrRange: nonBoldRange)
        
        label.sizeToFit()
        label.isUserInteractionEnabled = true
        label.tag = 1
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var getHelpView: UIView = {
        let helpView = UIView()
        helpView.translatesAutoresizingMaskIntoConstraints = false
        helpView.addSubview(self.getHelpLabel)
        self.getHelpLabel.center = helpView.center
        

        return helpView
    }()


    lazy var loginStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.addArrangedSubview(self.logoView)
        stackView.addArrangedSubview(self.usernameTextField)
        stackView.addArrangedSubview(self.passwordTextField)
        stackView.addArrangedSubview(self.loginButton)
        stackView.addArrangedSubview(self.getHelpView)
        
        return stackView
    }()
    
    lazy var lineViewLeft: UILineView = {
        let lineView = UILineView(frame: .zero)
        return lineView
    }()
    
    lazy var lineViewRight: UILineView = {
        let lineView = UILineView(frame: .zero)
        return lineView
    }()
    
    lazy var dividerWidth: CGFloat = {
        var stackViewWidth = self.view.frame.width - 70
        var spacing: CGFloat = 48
        
        return (stackViewWidth - 2*(spacing)) / 2
    }()
    
    lazy var orLabel: UILabel = {
        let label = UILabel()
        label.text = "OR"
        label.textColor = UIColor.white.withAlphaComponent(0.6)
        label.font = .systemFont(ofSize: 12.0, weight: UIFontWeightSemibold)
        label.sizeToFit()
        label.textAlignment = .center

        return label
    }()
    
    
    lazy var dividerView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 24
        
        
        stackView.addArrangedSubview(self.lineViewLeft)
        stackView.addArrangedSubview(self.orLabel)
        stackView.addArrangedSubview(self.lineViewRight)

        return stackView
    }()
    
    lazy var facebookLoginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Log In With Facebook", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 14.0)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.gray, for: .highlighted)
        
        let fbLogo = UIImage(named: "facebook-white")!

        button.setImage(fbLogo, for: .normal)
        button.titleEdgeInsets = UIEdgeInsetsMake(0, 8, 0, -8)
        button.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 8)
        button.sizeToFit()

        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    lazy var facebookLoginView: UIView = {
        let view = UIView()
        view.addSubview(self.facebookLoginButton)
        return view
    }()
    
    lazy var facebookLoginStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = self.verticalSpacing
        stackView.addArrangedSubview(self.dividerView)
        stackView.addArrangedSubview(self.facebookLoginView)
        
        return stackView
    }()
    
    lazy var verticalSpacing: CGFloat = {
        return 24
    }()
    
    lazy var signupView: UIView = {
        let view = UIView()
        view.addSubview(self.signupLabel)
        view.layer.backgroundColor = UIColor.white.withAlphaComponent(0.08).cgColor
        
        let topBorder = CALayer()
        topBorder.backgroundColor = UIColor.white.withAlphaComponent(0.2).cgColor
        topBorder.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 1.0)
        view.layer.addSublayer(topBorder)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    lazy var signupLabel: UILabel = {
        let label = UILabel()
        let text = "Don't have an account? Sign Up."
        let nonBoldRange = NSMakeRange(0, 23)
        let attributes = [
            NSFontAttributeName: UIFont.boldSystemFont(ofSize: 12.0),
            NSForegroundColorAttributeName: UIColor.white
        ]
        
        let nonAttributes = [
            NSFontAttributeName: UIFont.systemFont(ofSize: 12.0),
            NSForegroundColorAttributeName: UIColor.white
        ]
        
        label.attributedText = text.NSStringWithAttributes(attributes: attributes, nonAttributes: nonAttributes, nonAttrRange: nonBoldRange)
        
        label.sizeToFit()
        label.isUserInteractionEnabled = true
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.tag = 2
        return label
    }()
    
    // TODO: Signup View and buttons
    lazy var signUpView: UIView = {
        let view = UIView()
        
        return view
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        super.hideKeyboardWhenTappedAround()
        self.usernameTextField.addTarget(self, action: #selector(LoginViewController.textFieldEmptyCheck(sender:)), for: .editingChanged)
        self.passwordTextField.addTarget(self, action: #selector(LoginViewController.textFieldEmptyCheck(sender:)), for: .editingChanged)
        
        self.view.layer.addSublayer(gradient)
        
        configureTapRecognizer()
        
    }
    
    
    func configureTapRecognizer() {
        let getHelpTap = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.handleTapOnLabel(tapGesture:)))
        let signupTap = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.handleTapOnLabel(tapGesture:)))
        
        
        getHelpLabel.addGestureRecognizer(getHelpTap)
        signupLabel.addGestureRecognizer(signupTap)
        
        
    }
    
    // TODO: Present view controllers for each action tapped
    func handleTapOnLabel(tapGesture: UITapGestureRecognizer) {
        let view = tapGesture.view!
        let range = view.tag == 1 ? NSMakeRange(27, 20) : NSMakeRange(24, 8)
        let label = view.tag == 1 ? getHelpLabel : signupLabel
        let didTapLink = tapGesture.didTapAttributedTextInLabel(label: label, inRange: range)
        if didTapLink {
            print("Tapped!")
        }
    }
    
    override func viewWillLayoutSubviews() {
        view.addSubview(loginStackView)
        view.addSubview(facebookLoginStackView)
        view.addSubview(signupView)
        loginStackView.translatesAutoresizingMaskIntoConstraints = false
        facebookLoginStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            usernameTextField.heightAnchor.constraint(equalToConstant: 44),
            passwordTextField.heightAnchor.constraint(equalToConstant: 44),
            loginButton.heightAnchor.constraint(equalToConstant: 44),
            loginStackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 35),
            loginStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 64),
            loginStackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -35),
            getHelpLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            getHelpLabel.topAnchor.constraint(equalTo: getHelpView.topAnchor),
            getHelpView.leftAnchor.constraint(equalTo: loginStackView.leftAnchor),
            getHelpView.rightAnchor.constraint(equalTo: loginStackView.rightAnchor),
            getHelpView.heightAnchor.constraint(equalToConstant: 20),
            facebookLoginStackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 35),
            facebookLoginStackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -35),
            facebookLoginStackView.topAnchor.constraint(equalTo: loginStackView.bottomAnchor, constant: verticalSpacing),
            lineViewLeft.heightAnchor.constraint(equalToConstant: 1),
            lineViewLeft.widthAnchor.constraint(equalToConstant: dividerWidth),
            lineViewRight.heightAnchor.constraint(equalToConstant: 1),
            lineViewRight.widthAnchor.constraint(equalToConstant: dividerWidth),
            facebookLoginView.heightAnchor.constraint(equalToConstant: 30),
            facebookLoginButton.centerXAnchor.constraint(equalTo: loginStackView.centerXAnchor),
            facebookLoginButton.centerYAnchor.constraint(equalTo: facebookLoginView.centerYAnchor),
            
            signupView.heightAnchor.constraint(equalToConstant: 56),
            signupView.leftAnchor.constraint(equalTo: view.leftAnchor),
            signupView.rightAnchor.constraint(equalTo: view.rightAnchor),
            signupView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            signupLabel.centerXAnchor.constraint(equalTo: signupView.centerXAnchor),
            signupLabel.centerYAnchor.constraint(equalTo: signupView.centerYAnchor)
        ])
    }
    
    
}

// UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {
    
    // Return key to dismiss keyboarrd
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return false
    }
    
    // Disable/enable login button if text fields are empty/filled in
    func textFieldEmptyCheck(sender: UITextField) {
        guard let username = usernameTextField.text, let password = passwordTextField.text, !username.isEmpty, !password.isEmpty else {
            loginButton.isEnabled = false
            return
        }
        loginButton.isEnabled = true
    }
}

// Animations

extension LoginViewController: CAAnimationDelegate {
    
    // Add animation to gradient
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        animator.animateGradient()
    }
    
}









