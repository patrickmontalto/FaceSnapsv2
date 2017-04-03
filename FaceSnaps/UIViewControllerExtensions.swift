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
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func addKeyboardObservers(showSelector: Selector, hideSelector: Selector, object: Any? = nil) {
        NotificationCenter.default.addObserver(self, selector: showSelector, name: NSNotification.Name.UIKeyboardWillShow, object: object)
        NotificationCenter.default.addObserver(self, selector: hideSelector, name: NSNotification.Name.UIKeyboardWillHide, object: object)
    }
    
    func removeKeyboardObservers(object: Any? = nil) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: self.view.window)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: self.view.window)
    }
    
    // MARK: Detect device orientation
    func addDeviceOrientationObserver(selector: Selector) {
        NotificationCenter.default.addObserver(self, selector: selector, name: NSNotification.Name.UIDeviceOrientationDidChange, object: UIDevice.current)
    }

    func removeDeviceOrientationObserver() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIDeviceOrientationDidChange, object: UIDevice.current)
    }
    
    
    func createPhotoAlertController(delegate: FSImagePickerControllerDelegate, mediaPickerManager: MediaPickerManager) -> UIAlertController {
        let controller = UIAlertController(title: "", message: nil, preferredStyle: .actionSheet)
        
        let attributedTitle = NSAttributedString(string: "Change Profile Photo", attributes: [
            NSFontAttributeName: UIFont.systemFont(ofSize: 16.0, weight: UIFontWeightMedium),
            NSForegroundColorAttributeName: UIColor.black
            ])
        
        controller.setValue(attributedTitle, forKey: "attributedTitle")
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            // .. cancel
        })
        
        let takePhoto = UIAlertAction(title: "Take Photo", style: .default, handler: { (action) in
            let vc = FSImagePickerController()
            vc.delegate = delegate
            self.present(vc, animated: true, completion: nil)
        })
        
        let chooseFromLibrary = UIAlertAction(title: "Choose from Library", style: .default, handler: { (action) in
            // Present photo library
            mediaPickerManager.presentImagePickerController(animated: true, withSourceType: .photoLibrary)
        })
        
        controller.addAction(takePhoto)
        controller.addAction(chooseFromLibrary)
        controller.addAction(cancelAction)
        
        return controller
    }
    
    // MARK: - Post update notification
    func observePostUpdateNotifications(responseSelector: Selector) {
        NotificationCenter.default.addObserver(self, selector: responseSelector, name: Notification.Name.postWasModifiedNotification, object: nil)
    }
}
