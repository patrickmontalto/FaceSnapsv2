//
//  UsernameTextField.swift
//  FaceSnaps
//
//  Created by Patrick Montalto on 1/9/17.
//  Copyright © 2017 Patrick Montalto. All rights reserved.
//


import UIKit
/// Custom UITextField that contains code for multiple interactivity and networking views within the text field
class UsernameTextField: UITextField {
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        view.hidesWhenStopped = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var refreshImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "refresh")!)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var availabilityImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named:"cross_circle"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isHidden = true
        return imageView
    }()
    
    convenience init() {
        self.init(frame: .zero)
        // Set white placeholder
        self.attributedPlaceholder = NSAttributedString(string: "Username", attributes: [NSForegroundColorAttributeName: UIColor.lightGray])
        self.textColor = .black
        self.font = .systemFont(ofSize: 14)
        
        self.backgroundColor = .extraLightGray
        self.layer.cornerRadius = 4.0
        self.clearButtonMode = UITextFieldViewMode.whileEditing
        self.autocapitalizationType = .none
        
        self.addSubview(refreshImageView)
        self.addSubview(availabilityImageView)
        self.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            refreshImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            refreshImageView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -6),
            availabilityImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            availabilityImageView.rightAnchor.constraint(equalTo: refreshImageView.leftAnchor, constant: -8),
            activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            activityIndicator.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -12)
        ])

        layer.borderColor = UIColor.lightGray.cgColor
        layer.borderWidth = 0.5
        
        autocorrectionType = .no
        clearButtonMode = .never
        returnKeyType = .next
    }
    
    func toggleSubviewState(forResponse available: Bool) {
        refreshImageView.isHidden = false
        activityIndicator.stopAnimating()
        if available {
            availabilityImageView.image = UIImage(named: "check_circle")!
        } else {
            availabilityImageView.image = UIImage(named: "cross_circle")!
        }
        availabilityImageView.isHidden = false
    }
    
    func setSubviewLoadingState() {
        DispatchQueue.main.async {
            // Hide refresh  image view
            self.refreshImageView.isHidden = true
            // Hide availability image view
            self.availabilityImageView.isHidden = true
            // Show spinner
            self.activityIndicator.startAnimating()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let padding = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 56);
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
}
