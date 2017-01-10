//
//  UsernameSignUpController.swift
//  FaceSnaps
//
//  Created by Patrick on 1/6/17.
//  Copyright © 2017 Patrick Montalto. All rights reserved.
//

import UIKit

class UsernameSignUpController: UIViewController {
    
    // TODO: Make this a struct called ProtoUser?
    var email: String!
    var fullName: String!
    var password: String!
    var profileImage: UIImage?
    
    // TODO: "Create Username"
    lazy var pageTitle: UILabel = {
        let label = UILabel()
        label.text = "Create Username"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20.0)
        return label
    }()
    
    // TODO: Add a username or use our own suggestion. You can change this at any time.
    lazy var formDirections: UILabel = {
        let label = UILabel()
        label.text = "Add a username or use our suggestion. You can change this at any time."
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16.0)
        label.numberOfLines = 0
        return label
    }()
    
    lazy var suggestUsernameTapGesture: UITapGestureRecognizer = {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(refreshUsername))
        return recognizer
    }()
    
    // TODO: When text entry stops, query API to see if available
    // TODO: Put checkmark in TF when available
    // TODO: Put reload button to randomly generate a new username (fullname + 4 random numbers)
    lazy var usernameTextField: UsernameTextField = {
        let text = "Username"
        let textField = UsernameTextField(text: text)
        
        textField.delegate = self
        
        // Add gesture to textField refresh image
        textField.refreshImageView.addGestureRecognizer(self.suggestUsernameTapGesture)
        textField.refreshImageView.isUserInteractionEnabled = true
        
        // TODO: Once text entry stops, make call to server checking if username is available
        // if it is available, put gray checkmark
        // if not, put (x)
        
        return textField
    }()
    
    // Create the username generator
    lazy var usernameGenerator: UsernameGenerator = {
        return UsernameGenerator(fullName: self.fullName)
    }()
    
    lazy var nextButton: NextButton = {
        return NextButton(frame: .zero)
    }()

    lazy var usernameStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = 16
        
        stackView.addArrangedSubview(self.formDirections)
        stackView.addArrangedSubview(self.usernameTextField)
        stackView.addArrangedSubview(self.nextButton)
        
        // TODO: As typing, replace spaces with underscores
        return stackView
    }()
    
    // Already have an account? Sign In.
    lazy var signInView: LoginBottomView = {
        let view = LoginBottomView(labelType: .signIn, topBorderColor: .lightGray)
        
        view.interactableLabel.setTextColors(nonBoldColor: .lightGray, boldColor: .buttonBlue)
        return view
    }()
    
    // TODO: Add target to button submit to API and sign in
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add tap recognizer for bottom view
        configureTapRecognizer()
        
        // Add target action for usernameTextField
        usernameTextField.addTarget(self, action: #selector(textFieldEmptyCheck(sender:)), for: .editingChanged)
        
        // Add target action for next button
        nextButton.addTarget(self, action: #selector(nextButtonTapped(sender:)), for: .touchUpInside)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        view.addSubview(pageTitle)
        view.addSubview(usernameStackView)
        view.addSubview(signInView)
        
        pageTitle.translatesAutoresizingMaskIntoConstraints = false
        usernameStackView.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
                pageTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                pageTitle.topAnchor.constraint(equalTo: view.topAnchor, constant: 36),
                usernameStackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 36),
                usernameStackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -36),
                usernameStackView.topAnchor.constraint(equalTo: pageTitle.bottomAnchor, constant: 20),
                nextButton.heightAnchor.constraint(equalTo: usernameTextField.heightAnchor),
                signInView.leftAnchor.constraint(equalTo: view.leftAnchor),
                signInView.rightAnchor.constraint(equalTo: view.rightAnchor),
                signInView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                usernameTextField.heightAnchor.constraint(equalToConstant: 44)

        ])
    }
    
    // MARK: - Refresh username suggestion
    @objc private func refreshUsername() {
        usernameTextField.text = usernameGenerator.suggestUsername()
        usernameTextField.sendActions(for: .editingChanged)
    }
    
    // MARK: - Submit username to complete sign up
    func nextButtonTapped(sender: UIButton) {
        // TODO: Check if username is allowed
        // Submit to API : username, password, full name, image data
        // if success, show home screen
    }
    
    // MARK: - Sign In tapped
    func configureTapRecognizer() {
        signInView.interactableLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapOnLabel(tapGesture:))))
    }
    
    func handleTapOnLabel(tapGesture: UITapGestureRecognizer) {
        let label = signInView.interactableLabel
        if tapGesture.didTapAttributedTextInLabel(label: label, inRange: label.boldRange) {
            // Go back
            _ = self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
}

// MARK: UITextFieldDelegate
extension UsernameSignUpController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // TODO: Have a timer for 2 seconds, if it reaches 2 seconds, run through textfieldDidEndEditing
        // if the textfield does end editing prior to the 2 second mark, invalidate timer.
        guard let text = textField.text else { return true }

        let newLength = text.characters.count + string.characters.count - range.length
        if newLength > 30 { return false }
        if string == " " {
            textField.text! = (text + string).replacingOccurrences(of: " ", with: "_")
            return false
        }
        return true
    }
    
    // TODO: Check protocol default implementation
    // When editing ends, check with backend to see if username is available.
    func textFieldDidEndEditing(_ textField: UITextField) {
        // Make a request with the usernameTextField.text
        // Check if that response is already cached
        // Otherwise, proceed to network request
        // Put spinner inside usernameTextField
        // make request
        // remove spinner
        // Place either a checkbox or cross
    }
    
    // Return key to dismiss keyboarrd
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nextButton.sendActions(for: .touchUpInside)
        view.endEditing(true)
        return false
    }
    
    // Disable/enable login button if text fields are empty/filled in
    func textFieldEmptyCheck(sender: UITextField) {
        if usernameTextField.isBlank() {
            nextButton.isEnabled = false
        } else {
            nextButton.isEnabled = true
        }
    }
}
