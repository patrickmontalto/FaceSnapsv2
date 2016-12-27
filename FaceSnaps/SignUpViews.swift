//
//  SignUpViews.swift
//  FaceSnaps
//
//  Created by Patrick Montalto on 12/23/16.
//  Copyright © 2016 Patrick Montalto. All rights reserved.
//

import UIKit

class SignUpStackView: UIStackView {
    
    lazy var facebookSignUpButton: FacebookLoginButton = {
        return FacebookLoginButton(text: "Sign Up With Facebook")
    }()
    
    lazy var signUpWithEmail: UIButton = {
        let button = UIButton()
        
        button.setTitle("Sign Up With Email", for: .normal)
        button.setTitleColor(.extraLightGray, for: .highlighted)
        
        button.titleLabel?.font = .boldSystemFont(ofSize: 14.0)
        
        return button
    }()
    
    lazy var dividerWidth: CGFloat = {
        var stackViewWidth = UIScreen.main.bounds.width - 70
        var spacing: CGFloat = 48
        
        return (stackViewWidth - 2*(spacing)) / 2
    }()
    
    lazy var lineViewLeft: UILineView = {
        let lineView = UILineView(frame: .zero)
        return lineView
    }()
    
    lazy var lineViewRight: UILineView = {
        let lineView = UILineView(frame: .zero)
        return lineView
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
    
    convenience init(verticalSpacing: CGFloat) {
        self.init(frame: .zero)
        
        self.axis = .vertical
        self.spacing = verticalSpacing
        self.addArrangedSubview(facebookSignUpButton)
        self.addArrangedSubview(dividerView)
        self.addArrangedSubview(signUpWithEmail)
        
        // Constraints
        NSLayoutConstraint.activate([
            lineViewLeft.heightAnchor.constraint(equalToConstant: 1),
            lineViewLeft.widthAnchor.constraint(equalToConstant: dividerWidth),
            lineViewRight.heightAnchor.constraint(equalToConstant: 1),
            lineViewRight.widthAnchor.constraint(equalToConstant: dividerWidth),
        ])
    }
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setTargetForFacebookButton(target: Any?, action: Selector) {
        facebookSignUpButton.addTarget(target, action: action, for: .touchUpInside)
    }
    
    func setTargetForEmailSignUp(target: Any?, action: Selector) {
        signUpWithEmail.addTarget(target, action: action, for: .touchUpInside)
    }
    
    
}
