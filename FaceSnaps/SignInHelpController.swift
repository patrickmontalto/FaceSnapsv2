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
    lazy var lockIcon: UIImageView = {
        let image = UIImage(named: "trouble-lock")
        let imageView = UIImageView(image: image)
        
        imageView.contentMode = .scaleAspectFit

        return imageView
    }()
    
    lazy var lockIconHeight: CGFloat = {
        switch UIDevice.current.deviceType {
        case .iPhone35in:
            return 120
        case .iPhone40in:
            return 132
        case .iPhone47in, .iPhone55in:
            return 160
        default: break
        }
        return 120
    }()
    
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
    
    lazy var titleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.addArrangedSubview(self.lockIcon)
        stackView.addArrangedSubview(self.troubleLoggingInLabel)
        stackView.addArrangedSubview(self.helpDescriptionLabel)
        
        stackView.alignment = .center
        stackView.axis = .vertical
        stackView.spacing = 12
        
        return stackView
    }()
    // Username textfield
    lazy var usernameTextField: LoginTextField = {
        let textField = LoginTextField(text: "Username")
        textField.returnKeyType = .send
        textField.autocapitalizationType = .none
        textField.delegate = self
        
        return textField
    }()
    // Send Login Link button
    lazy var sendLoginLinkButton: UIButton = {
        let button = UIButton()
        button.setTitle("Send Login Link", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 14)
        
        // TODO: is extra light gray the right color for the border ?
        button.backgroundColor = .clear
        button.layer.borderColor = UIColor.superLightGray.cgColor
        button.layer.borderWidth = 1.5
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.superLightGray, for: .disabled)
        button.layer.cornerRadius = 4.0
        button.isEnabled = false
        button.addTarget(self, action: #selector(SignInHelpController.sendLoginLinkTapped(sender:)), for: .touchUpInside)
        
        return button
    }()
    // Stack view container for form
    lazy var loginLinkStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.addArrangedSubview(self.usernameTextField)
        stackView.addArrangedSubview(self.sendLoginLinkButton)
        
        stackView.spacing = 16
        stackView.axis = .vertical
        
        return stackView
    }()
    
    // OR Log in With Facebook button
    lazy var facebookLoginStackView: FacebookLoginStackView = {
        return FacebookLoginStackView(verticalSpacing: 16)
    }()
    // Back to Log In Button view
    lazy var backToLogInView: LoginBottomView = {
        return LoginBottomView(labelType: .goBack)
    }()
    
    // Hide status bar
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.layer.addSublayer(gradient)
        
        configureTapRecognizer()
        
        usernameTextField.addTarget(self, action: #selector(SignInHelpController.textFieldEmptyCheck(sender:)), for: .editingChanged)
        
        // Observe keyboard notifications to slide screen up/down
        addKeyboardObservers(showSelector: #selector(SignInHelpController.keyboardWillShow(sender:)), hideSelector: #selector(SignInHelpController.keyboardWillHide(sender:)))
    }
    
    // Add animation to gradient
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animator.animateGradient()
    }
    
    override func viewWillLayoutSubviews() {
        view.addSubview(titleStackView)
        view.addSubview(loginLinkStackView)
        view.addSubview(facebookLoginStackView)
        view.addSubview(backToLogInView)
        
        titleStackView.translatesAutoresizingMaskIntoConstraints = false
        loginLinkStackView.translatesAutoresizingMaskIntoConstraints = false
        facebookLoginStackView.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            lockIcon.heightAnchor.constraint(equalToConstant: lockIconHeight),
            titleStackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 64),
            titleStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 64),
            titleStackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -64),
            
            loginLinkStackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 36),
            loginLinkStackView.topAnchor.constraint(equalTo: titleStackView.bottomAnchor, constant: 12),
            loginLinkStackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -36),
            sendLoginLinkButton.heightAnchor.constraint(equalTo: usernameTextField.heightAnchor),
            
            facebookLoginStackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 36),
            facebookLoginStackView.topAnchor.constraint(equalTo: loginLinkStackView.bottomAnchor, constant: 24),
            facebookLoginStackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -36),
            
            backToLogInView.leftAnchor.constraint(equalTo: view.leftAnchor),
            backToLogInView.rightAnchor.constraint(equalTo: view.rightAnchor),
            backToLogInView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeKeyboardObservers()
    }
    
    // MARK: Go Back Button Behavior
    func configureTapRecognizer() {
        backToLogInView.interactableLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(SignInHelpController.handleTapOnLabel(tapGesture:))))
    }
    
    func handleTapOnLabel(tapGesture: UITapGestureRecognizer) {
        let label = backToLogInView.interactableLabel
        if tapGesture.didTapAttributedTextInLabel(label: label, inRange: label.boldRange) {
            // GO BACK
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    func sendLoginLinkTapped(sender: UIButton) {
        // TODO: Send login link here
        // Is username empty?
        print("Sending login link!")
    }
    
    // MARK: Keyboard will show/hide
    func keyboardWillShow(sender: NSNotification) {
        // Slide screen up
        if self.view.frame.origin.y == 0 {
            self.view.frame.origin.y -= 100
        }
    }
    
    func keyboardWillHide(sender: NSNotification) {
        // Slide screen down
        
        if self.view.frame.origin.y != 0{
            self.view.frame.origin.y += 100
        }
    }
    
}

// MARK: UITextFieldDelegate

extension SignInHelpController: UITextFieldDelegate {
    
    // Return key to dismiss keyboarrd
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendLoginLinkButton.sendActions(for: .touchUpInside)
        view.endEditing(true)
        return false
    }
    
    // Disable/enable login button if text fields are empty/filled in
    func textFieldEmptyCheck(sender: UITextField) {
        if usernameTextField.isBlank() {
            sendLoginLinkButton.isEnabled = false
        } else {
            sendLoginLinkButton.isEnabled = true
        }
    }
}











