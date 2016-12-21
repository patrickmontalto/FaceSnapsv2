//
//  UIViewControllerExtensions.swift
//  OnTheMap
//
//  Created by Patrick Montalto on 5/12/16.
//  Copyright © 2016 swift. All rights reserved.
//

import UIKit

extension UIViewController {
    
    // MARK: Display Alert
    func displayAlert(withMessage message: String, title: String, actions: [UIAlertAction]) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            for action in actions {
                alertController.addAction(action)
            }
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    // MARK: Display Notification Alert with Dismiss button
    func displayNotification(withMessage message: String, completionHandler: ((UIAlertAction) -> Void)?) {
        let dismiss = UIAlertAction(title: "Dismiss", style: .default, handler: completionHandler)
        displayAlert(withMessage: message, title: "", actions: [dismiss])
    }
    
    // MARK: Hide keyboard when touch outside of textfield
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func addKeyboardObservers(showSelector: Selector, hideSelector: Selector) {
        NotificationCenter.default.addObserver(self, selector: showSelector, name: NSNotification.Name.UIKeyboardWillShow, object: self.view.window)
        NotificationCenter.default.addObserver(self, selector: hideSelector, name: NSNotification.Name.UIKeyboardWillHide, object: self.view.window)
    }
    
    func removeKeyboardObservers() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: self.view.window)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: self.view.window)
    }
}
