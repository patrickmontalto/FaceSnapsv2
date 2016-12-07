//
//  LoginController.swift
//  FaceSnaps
//
//  Created by Patrick Montalto on 11/29/16.
//  Copyright © 2016 Patrick Montalto. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    
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

        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var getHelpView: UIView = {
        let helpView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 20))
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
    
//    lazy var facebookLoginStackView: UIStackView {
//        
//    }()
    
    lazy var gradient: CAGradientLayer = {
        
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.frame = self.view.bounds
        
        gradientLayer.colors = [GradientLayerAnimator.color1, GradientLayerAnimator.color2]
        
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        
        return gradientLayer
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.hideKeyboardWhenTappedAround()
        self.usernameTextField.addTarget(self, action: #selector(LoginViewController.textFieldEmptyCheck(sender:)), for: .editingChanged)
        self.passwordTextField.addTarget(self, action: #selector(LoginViewController.textFieldEmptyCheck(sender:)), for: .editingChanged)
        
        self.view.layer.addSublayer(gradient)

        getHelpLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(LoginViewController.handleTapOnLabel(tapGesture:))))

    }
    
    func handleTapOnLabel(tapGesture: UITapGestureRecognizer) {
        let range = NSMakeRange(27, 20)
        let didTapLink = tapGesture.didTapAttributedTextInLabel(label: getHelpLabel, inRange: range)
        if didTapLink {
            print("Tapped!")
        }
    }
    
    override func viewWillLayoutSubviews() {
        view.addSubview(loginStackView)
        loginStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            usernameTextField.heightAnchor.constraint(equalToConstant: 44),
            passwordTextField.heightAnchor.constraint(equalToConstant: 44),
            loginButton.heightAnchor.constraint(equalToConstant: 44),
            loginStackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 35),
            loginStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 64),
            loginStackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -35),
            getHelpLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            getHelpLabel.topAnchor.constraint(equalTo: getHelpView.topAnchor)
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









