//
//  MediaPickerManager.swift
//  FaceSnaps
//
//  Created by Patrick Montalto on 10/2/16.
//  Copyright © 2016 Patrick Montalto. All rights reserved.
//

import UIKit
import MobileCoreServices
import AVFoundation

// Restrict delegate to reference type only
protocol MediaPickerManagerDelegate: class {
    func mediaPickerManager(manager: MediaPickerManager, didFinishPickingImage image: UIImage)
}


class MediaPickerManager: NSObject {
    
    private let imagePickerController = UIImagePickerController()
    
    // Using dependency injection, inject the view controller:
    private let presentingViewController: UIViewController
    
    // Delegate: weak so only a reference type is assigned (avoiding reference cycle)
    weak var delegate: MediaPickerManagerDelegate?
    
    init(presentingViewController: UIViewController) {
        self.presentingViewController = presentingViewController
        super.init()
        
        imagePickerController.delegate = self
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePickerController.sourceType = .camera
            imagePickerController.cameraDevice = .front
        } else {
            imagePickerController.sourceType = .photoLibrary
        }
        imagePickerController.mediaTypes = [kUTTypeImage as String]
        
        // Edit image to square aspect ratio
        imagePickerController.allowsEditing = true
        
        // Add observer for Camera Device Orientation
        NotificationCenter.default.addObserver(self, selector: #selector(MediaPickerManager.cameraChanged(notification:)), name: .AVCaptureSessionDidStartRunning, object: nil)
    }
    
    func presentImagePickerController(animated: Bool) {
        presentingViewController.present(imagePickerController, animated: animated
            , completion: nil)
    }
    
    func dismissImagePickerController(animated: Bool, completion: @escaping (() -> Void)) {
        imagePickerController.dismiss(animated: animated, completion: completion)
    }
    
    deinit {
        // Remove observer
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: Camera Orientation Change
    func cameraChanged(notification: Notification) {
        DispatchQueue.main.async {
            if self.imagePickerController.cameraDevice == .front {
                self.imagePickerController.cameraViewTransform = CGAffineTransform.identity
                self.imagePickerController.cameraViewTransform = (self.imagePickerController.cameraViewTransform).scaledBy(x: -1, y: 1)
            } else {
                self.imagePickerController.cameraViewTransform = CGAffineTransform.identity
            }
        }
    }

}

extension MediaPickerManager: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let image = info[UIImagePickerControllerEditedImage] as! UIImage
        
//        let image = UIImage(cgImage: editedImage.cgImage!, scale: editedImage.scale, orientation: .upMirrored)
        
        // Pass image to our delegate
        delegate?.mediaPickerManager(manager: self, didFinishPickingImage: image)
    }
}

















