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
    
    lazy var usernameTextField: UsernameTextField = {
        let textField = UsernameTextField()
        
        textField.delegate = self
        
        // Add gesture to textField refresh image
        textField.refreshImageView.addGestureRecognizer(self.suggestUsernameTapGesture)
        textField.refreshImageView.isUserInteractionEnabled = true
        
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
        
        return stackView
    }()
    
    // Already have an account? Sign In.
    lazy var signInView: LoginBottomView = {
        let view = LoginBottomView(labelType: .signIn, topBorderColor: .lightGray)
        
        view.interactableLabel.setTextColors(nonBoldColor: .lightGray, boldColor: .buttonBlue)
        return view
    }()
    
    // MARK: Timer for editing text checking availability of username
    var timer: Timer? {
        didSet {
            // When timer is set, reset usernameTextField UI
            usernameTextField.availabilityImageView.isHidden = true
            usernameTextField.refreshImageView.isHidden = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add tap recognizer for bottom view
        configureTapRecognizer()
        
        // Add target action for usernameTextField
        usernameTextField.addTarget(self, action: #selector(textFieldEmptyCheck(sender:)), for: .editingChanged)
        usernameTextField.addTarget(self, action: #selector(triggerUsernameTextFieldTimer), for: .editingChanged)
        
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
        // TODO: Check if username is allowed (separate network request)
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

// MARK: - UITextFieldDelegate
extension UsernameSignUpController: UITextFieldDelegate {
    
    // MARK: Hide availability image view
    func textFieldDidBeginEditing(_ textField: UITextField) {
        guard textField is UsernameTextField else { return }
        (textField as! UsernameTextField).availabilityImageView.isHidden = true
    }
    // MARK: Check if username is available
    func textFieldDidEndEditing(_ textField: UITextField) {
        // Invalidate the timer if it is running
        timer?.invalidate()
        checkUsernameAvailability()
    }

    // MARK: Substitute underscores for spaces and disallow tabs
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }

        let newLength = text.characters.count + string.characters.count - range.length
        if newLength > 30 { return false }
        if string == " " {
            textField.text! = (text + string).replacingOccurrences(of: " ", with: "_")
            return false
        } else if string == "\t" {
            textField.text! = text
            return false
        }
        return true
    }
    
    // MARK: Return key to dismiss keyboarrd
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nextButton.sendActions(for: .touchUpInside)
        view.endEditing(true)
        return false
    }
    
    // MARK: Disable/enable login button if text fields are empty/filled in
    func textFieldEmptyCheck(sender: UITextField) {
        if usernameTextField.isBlank() {
            nextButton.isEnabled = false
        } else {
            nextButton.isEnabled = true
        }
    }
    
    // MARK: Begin timer when textfield changes
    func triggerUsernameTextFieldTimer() {
        timer?.invalidate()
        // TODO: Have a timer for 2 seconds, if it reaches 2 seconds, run through textfieldDidEndEditing
        timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(checkUsernameAvailability), userInfo: nil, repeats: false)
    }
    
    // MARK: Make API call to see if username is available. Update UI Accordingly
    func checkUsernameAvailability() {
        // Check if the textField is blank
        guard usernameTextField.isBlank() == false else { return }
        
        let username = usernameTextField.text!
        usernameTextField.setSubviewLoadingState()
        // Make call to network checking if username is available
        FaceSnapsClient.sharedInstance.checkAvailability(forUserCredential: username) { (available, errors) in
            if errors != nil {
                print(errors!["title"]!)
            } else {
                DispatchQueue.main.async {
                    self.usernameTextField.toggleSubviewState(forResponse: available)
                }
            }
        }

    }
}
