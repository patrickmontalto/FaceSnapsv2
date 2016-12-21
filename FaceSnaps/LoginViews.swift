//
//  LoginViews.swift
//  FaceSnaps
//
//  Created by Patrick Montalto on 12/14/16.
//  Copyright © 2016 Patrick Montalto. All rights reserved.
//

import UIKit

// MARK: Login Stack View
class LoginStackView: UIStackView {
    
    private weak var parentView: UITextFieldDelegate?
    
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
        let textField = LoginTextField(text: "Username")
        textField.delegate = self.parentView
        textField.returnKeyType = .next
        
        return textField
    }()
    
    lazy var passwordTextField: LoginTextField = {
        let textField = LoginTextField(text: "Password")
        textField.delegate = self.parentView
        textField.isSecureTextEntry = true
        textField.returnKeyType = .go
        
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
    
    lazy var getHelpLabel: InteractableLabel = {
        let label = InteractableLabel(type: .getHelp)
        label.tag = 1
        
        return label
    }()
    
    lazy var getHelpView: UIView = {
        let helpView = UIView()
        helpView.translatesAutoresizingMaskIntoConstraints = false
        helpView.addSubview(self.getHelpLabel)
        self.getHelpLabel.center = helpView.center
        
        
        return helpView
    }()

    convenience init(parentView: UITextFieldDelegate) {
        self.init(frame: .zero)
        
        self.parentView = parentView
        
        self.alignment = .fill
        self.distribution = .fill
        self.axis = .vertical
        self.spacing = 16
        
        self.addArrangedSubview(self.logoView)
        self.addArrangedSubview(self.usernameTextField)
        self.addArrangedSubview(self.passwordTextField)
        self.addArrangedSubview(self.loginButton)
        self.addArrangedSubview(self.getHelpView)
        
        // Constraints
        NSLayoutConstraint.activate([
            usernameTextField.heightAnchor.constraint(equalToConstant: 44),
            passwordTextField.heightAnchor.constraint(equalToConstant: 44),
            loginButton.heightAnchor.constraint(equalToConstant: 44),
            getHelpLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            getHelpLabel.topAnchor.constraint(equalTo: getHelpView.topAnchor),
            getHelpView.leftAnchor.constraint(equalTo: self.leftAnchor),
            getHelpView.rightAnchor.constraint(equalTo: self.rightAnchor),
            getHelpView.heightAnchor.constraint(equalToConstant: 20),
        ])
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)

    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var usernameEmpty: Bool {
        return textFieldEmpty(textField: usernameTextField)
    }
    
    var passwordEmpty: Bool  {
        return textFieldEmpty(textField: passwordTextField)
    }
    
    func setLoginButton(enabled: Bool) {
        loginButton.isEnabled = enabled
    }
    
    func setLoginButtonTarget(target: Any, action: Selector) {
        loginButton.addTarget(target, action: action, for: .touchUpInside)
    }
    
    private func textFieldEmpty(textField: UITextField) -> Bool {
        guard let value = textField.text, !value.isEmpty else {
            return true
        }
        return false
    }
    
}

// MARK: Login Bottom Views


class LoginBottomView: UIView {
    
    var labelType: InteractableLabelType!
    
    
    lazy var interactableLabel: InteractableLabel = {
        let label = InteractableLabel(type: self.labelType)
        
        // FIXME: How to handle tags?
        label.tag = 2
        return label
    }()
    

    convenience init(labelType: InteractableLabelType) {
        self.init(frame: .zero)
        
        self.labelType = labelType

        self.addSubview(interactableLabel)
        layer.backgroundColor = UIColor.white.withAlphaComponent(0.08).cgColor
        
        let topBorder = CALayer()
        topBorder.backgroundColor = UIColor.white.withAlphaComponent(0.2).cgColor
        topBorder.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 1.0)
        layer.addSublayer(topBorder)
        translatesAutoresizingMaskIntoConstraints = false

        // Constraints
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalToConstant: 56),
            interactableLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            interactableLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
    override init(frame: CGRect) {
        self.labelType = .none
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

}







