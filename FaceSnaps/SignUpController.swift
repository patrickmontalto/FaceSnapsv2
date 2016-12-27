//
//  SignUpController.swift
//  FaceSnaps
//
//  Created by Patrick Montalto on 12/21/16.
//  Copyright © 2016 Patrick Montalto. All rights reserved.
//

import UIKit

class SignUpController: UIViewController {
    
    // Gradient
    lazy var gradient: CAGradientLayer = {
        return FaceSnapsGradient(parentView: self.view)
    }()
    
    lazy var animator: GradientLayerAnimator = {
        return GradientLayerAnimator(layer: self.gradient)
    }()
    
    // FaceSnaps logo
    lazy var logoView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "facesnaps-logo")!
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    // TODO: Configure heights
    lazy var logoViewHeight: CGFloat = {
        return 61
    }()
    
    // "Sign up to see photos and videos from your friends."
    lazy var logoStackView: UIStackView = {
        let stackView = UIStackView()
        
        let label = UILabel()
        label.text = "Sign up to see photos from your friends."
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 14.0)
        
        stackView.alignment = .center
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.addArrangedSubview(self.logoView)
        stackView.addArrangedSubview(label)
        
        return stackView
    }()
    
    lazy var logoStackViewTopDistance: CGFloat = {
        switch UIDevice.current.deviceType {
        case .iPhone35in:
            return 48
        case .iPhone40in:
            return 64
        case .iPhone47in, .iPhone55in:
            return 100
        default: break
        }
        return 61
    }()

    // OR
    // Sign Up with Email
    lazy var signUpStackView: SignUpStackView = {
        return SignUpStackView(verticalSpacing: 24)
    }()
    
    // By signing up, you agree to our Terms & Privacy Policy
    lazy var privacyPolicy: UILabel = {
        let label = UILabel()
        label.text = "By signing up, you agree to our Terms & Privacy Policy."
        label.font = .systemFont(ofSize: 12.0)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.textAlignment = .center
        
        return label
    }()

    // Already have an account? Sign In.
    lazy var signInView: LoginBottomView = {
        return LoginBottomView(labelType: .signIn)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.layer.addSublayer(gradient)
        
        configureTapRecognizer()
        
        signUpStackView.setTargetForFacebookButton(target: self, action: #selector(SignUpController.facebookSignUpTapped(sender:)))
        signUpStackView.setTargetForEmailSignUp(target: self, action: #selector(SignUpController.signUpWithEmailTapped(sender:)))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Show the navigation bar
        navigationController?.setNavigationBarHidden(false, animated: true)
        animator.animateGradient()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        view.addSubview(logoStackView)
        view.addSubview(signUpStackView)
        view.addSubview(privacyPolicy)
        view.addSubview(signInView)
        
        logoStackView.translatesAutoresizingMaskIntoConstraints = false
        signUpStackView.translatesAutoresizingMaskIntoConstraints = false
        logoView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            logoView.heightAnchor.constraint(equalToConstant: logoViewHeight),
            logoStackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 60),
            logoStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: logoStackViewTopDistance),
            logoStackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -60),
            
            signUpStackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 36),
            signUpStackView.topAnchor.constraint(equalTo: logoStackView.bottomAnchor, constant: 54),
            signUpStackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -36),
            
            privacyPolicy.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 60),
            privacyPolicy.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -60),
            privacyPolicy.bottomAnchor.constraint(equalTo: signInView.topAnchor, constant: -16),
            signInView.leftAnchor.constraint(equalTo: view.leftAnchor),
            signInView.rightAnchor.constraint(equalTo: view.rightAnchor),
            signInView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: false)

    }
    
    
    // MARK: Go Back Button Behavior
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
    // TODO: Login / Sign up with Facebook
    func facebookSignUpTapped(sender: UIButton) {
        print("Sign up/in with facebook!")
    }
    
    // TODO: Sign up with email tapped (EmailSignUpController)
    func signUpWithEmailTapped(sender: UIButton) {
        print("Sign up with email!")
    }
}
