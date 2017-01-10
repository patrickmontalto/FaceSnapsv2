//
//  UsernameTextField.swift
//  FaceSnaps
//
//  Created by Patrick Montalto on 1/9/17.
//  Copyright © 2017 Patrick Montalto. All rights reserved.
//

import UIKit

class UsernameTextField: UITextField {
    
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
    
    convenience init(text: String) {
        self.init(frame: .zero)
        // Set white placeholder
        self.attributedPlaceholder = NSAttributedString(string: text, attributes: [NSForegroundColorAttributeName: UIColor.lightGray])
        self.textColor = .black
        self.font = .systemFont(ofSize: 14)
        
        self.backgroundColor = .extraLightGray
        self.layer.cornerRadius = 4.0
        self.clearButtonMode = UITextFieldViewMode.whileEditing
        self.autocapitalizationType = .none
        
        self.addSubview(refreshImageView)
        self.addSubview(availabilityImageView)
        
        NSLayoutConstraint.activate([
            refreshImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            refreshImageView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -6),
            availabilityImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            availabilityImageView.rightAnchor.constraint(equalTo: refreshImageView.leftAnchor, constant: -8)
        ])

        layer.borderColor = UIColor.lightGray.cgColor
        layer.borderWidth = 0.5
        
        autocorrectionType = .no
        clearButtonMode = .never
        returnKeyType = .next
    }
    
    // TODO: keep this?
    func updateAvailabilityImageView(available: Bool) {
        if available {
            availabilityImageView.isHidden = false
            availabilityImageView.image = UIImage(named: "check_circle")!
        } else {
            availabilityImageView.isHidden = false
            availabilityImageView.image = UIImage(named: "cross_circle")!
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

// MARK: - UsernameTextFieldDelegate
protocol UsernameTextFieldDelegate: UITextFieldDelegate {
}



// TODO: Default implementation
extension UsernameTextFieldDelegate {
    
    override func textFieldDidBeginEditing(_ textField: UITextField) {
        // Hide availability image view (only if text changes when tapped in)
    }
    override func textFieldDidEndEditing(_ textField: UITextField) {
        // Hide refresh  image view
        // Hide availability image view
        // show spinner
        // Make call to network checking if username is available
        // if available:
        // set availabilityImageView image to check
        // else, set it to cross
        // remove spinner
        // unhide refresh image view
        // unhide availability image view
    }
}
