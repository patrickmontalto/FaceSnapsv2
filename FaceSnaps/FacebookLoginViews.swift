//
//  FacebookLoginViews.swift
//  FaceSnaps
//
//  Created by Patrick Montalto on 12/14/16.
//  Copyright © 2016 Patrick Montalto. All rights reserved.
//

import UIKit

// Facebook login button with left-aligned facebook logo
class FacebookLoginButton: UIButton {
    
    convenience init() {
        self.init(frame: .zero)
        
        self.setTitle("Log In With Facebook", for: .normal)
        self.titleLabel?.font = .boldSystemFont(ofSize: 14.0)
        self.setTitleColor(.white, for: .normal)
        self.setTitleColor(.gray, for: .highlighted)
        
        let fbLogo = UIImage(named: "facebook-white")!
        
        self.setImage(fbLogo, for: .normal)
        self.titleEdgeInsets = UIEdgeInsetsMake(0, 8, 0, -8)
        self.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 8)
        self.sizeToFit()
        
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// UIView container for facebook login button (used to center button)

class FacebookLoginView: UIView {
    
    var facebookLoginButton: FacebookLoginButton
    
    override init(frame: CGRect) {
        facebookLoginButton = FacebookLoginButton()
        
        super.init(frame: frame)
        
        self.addSubview(facebookLoginButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


// Stackview with divider, or label, and facebook login button (within a view)
class FacebookLoginStackView: UIStackView {
    
    var loginView: FacebookLoginView
    
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
        self.addArrangedSubview(dividerView)
        self.addArrangedSubview(loginView)
        
        // Constraints
        NSLayoutConstraint.activate([
            loginView.heightAnchor.constraint(equalToConstant: 30),
            loginView.facebookLoginButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            loginView.facebookLoginButton.centerYAnchor.constraint(equalTo: loginView.centerYAnchor),
            lineViewLeft.heightAnchor.constraint(equalToConstant: 1),
            lineViewLeft.widthAnchor.constraint(equalToConstant: dividerWidth),
            lineViewRight.heightAnchor.constraint(equalToConstant: 1),
            lineViewRight.widthAnchor.constraint(equalToConstant: dividerWidth),
        ])
    }
    
    override init(frame: CGRect) {
        loginView = FacebookLoginView(frame: .zero)
        
        super.init(frame: frame)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}








