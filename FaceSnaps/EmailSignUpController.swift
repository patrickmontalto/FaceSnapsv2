//
//  EmailSignUpController.swift
//  FaceSnaps
//
//  Created by Patrick Montalto on 12/27/16.
//  Copyright © 2016 Patrick Montalto. All rights reserved.
//

import UIKit

class EmailSignUpController: UIViewController {
    
    lazy var emailLabel: UILabel = {
        let label = UILabel()
        label.text = "Email"
        label.font = .systemFont(ofSize: 18.0, weight: UIFontWeightMedium)
        label.textAlignment = .center
        return label
    }()
    
    lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        
        return view
    }()
    
    lazy var emailTextField: LoginTextField = {
        let text = "Email Address"
        let textField = LoginTextField(text: text)
        
        textField.textColor = .black
        textField.attributedPlaceholder = NSAttributedString(string: text, attributes: [NSForegroundColorAttributeName: UIColor.lightGray])
        textField.backgroundColor = .extraLightGray
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth = 0.5

        textField.delegate = self
        textField.returnKeyType = .next
        
        return textField
    }()
    
    lazy var nextButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 4
        button.setTitle("Next", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14.0)
        button.setBackgroundColor(color: UIColor(red: 157/255, green: 204/255, blue: 245/255, alpha: 1.0), forUIControlState: .disabled)
        button.setBackgroundColor(color: UIColor(red: 62/255, green: 153/255, blue: 237/255, alpha: 1.0), forUIControlState: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.masksToBounds = true
        
        button.isEnabled = false
        
        return button
    }()
    
    lazy var signUpStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = 16
        
        stackView.addArrangedSubview(self.emailLabel)
        stackView.addArrangedSubview(self.lineView)
        stackView.addArrangedSubview(self.emailTextField)
        stackView.addArrangedSubview(self.nextButton)
        
        return stackView
    }()
    
    
    // Already have an account? Sign In.
    lazy var signInView: LoginBottomView = {
        let view = LoginBottomView(labelType: .signIn, topBorderColor: .lightGray)
        
        view.interactableLabel.setTextColors(nonBoldColor: .lightGray, boldColor: .buttonBlue)
        return view
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTapRecognizer()
        nextButton.addTarget(self, action: #selector(EmailSignUpController.nextButtonTapped(sender:)), for: .touchUpInside)
        
        emailTextField.addTarget(self, action: #selector(EmailSignUpController.textFieldEmptyCheck(sender:)), for: .editingChanged)

        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        view.addSubview(signUpStackView)
        view.addSubview(signInView)
        
        signUpStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
                signUpStackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 36),
                signUpStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 36),
                signUpStackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -36),
                lineView.heightAnchor.constraint(equalToConstant: 1.0),
                signInView.leftAnchor.constraint(equalTo: view.leftAnchor),
                signInView.rightAnchor.constraint(equalTo: view.rightAnchor),
                signInView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                nextButton.heightAnchor.constraint(equalTo: emailTextField.heightAnchor)
        ])
        
    }
    
    // MARK: Sign In tapped
    func configureTapRecognizer() {
        signInView.interactableLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(SignUpController.handleTapOnLabel(tapGesture:))))
    }
    
    func handleTapOnLabel(tapGesture: UITapGestureRecognizer) {
        let label = signInView.interactableLabel
        if tapGesture.didTapAttributedTextInLabel(label: label, inRange: label.boldRange) {
            // Go back
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    // MARK: Submit email to sign up
    func nextButtonTapped(sender: UIButton) {
        guard let email = emailTextField.text else {
            return
        }
        
        // TODO: Check if email is taken yet
        if emailAvailable(email: email) {
            // Present EmailSignUpControllerWithAccount
            let vc = EmailSignUpControllerWithAccount()
            vc.email = email
            vc.view.backgroundColor = .white
            navigationController?.pushViewController(vc, animated: true)
        } else {
            // TODO: Red dropdown saying Email already taken. OR Please enter a valid email.
        }
        // If not, proceed to Full Name and Password and photo screen
        // Then proceed to Username screen
        // Then find Facebook Friends?
        // Search Contacts (skipping)
        
    }
    
    // TODO: Check email registration via API - move this later
    func emailAvailable(email: String) -> Bool {
        return true
    }
    
}

// MARK: UITextFieldDelegate

extension EmailSignUpController: UITextFieldDelegate {
    
    // Return key to dismiss keyboarrd
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nextButton.sendActions(for: .touchUpInside)
        view.endEditing(true)
        return false
    }
    
    // Disable/enable login button if text fields are empty/filled in
    func textFieldEmptyCheck(sender: UITextField) {
        if emailTextField.isBlank() {
            nextButton.isEnabled = false
        } else {
            nextButton.isEnabled = true
        }
    }
}











