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
        
        imagePickerController.mediaTypes = [kUTTypeImage as String]
        
//        // Edit image to square aspect ratio
//        imagePickerController.allowsEditing = true
//        
        // Add observer for Camera Device Orientation
        NotificationCenter.default.addObserver(self, selector: #selector(MediaPickerManager.cameraChanged(notification:)), name: .AVCaptureSessionDidStartRunning, object: nil)
    }
    
    // Present the Image Picker Controller (attached to the MediaPickerManager) on the presenting View Controller.
    func presentImagePickerController(animated: Bool, withSourceType sourceType: UIImagePickerControllerSourceType) {
        
        if !UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePickerController.sourceType = .photoLibrary
        } else {
            imagePickerController.sourceType = sourceType
        }
        
        if sourceType == .camera {
            imagePickerController.cameraDevice = .front
            
            // MARK: Camera Overlay
            var f: CGRect = imagePickerController.view.bounds
            f.size.height -= imagePickerController.navigationBar.bounds.size.height
            let barHeight = (f.size.height - f.size.width) / 2
            UIGraphicsBeginImageContext(f.size)
            UIColor.white.withAlphaComponent(0.5).set()
            UIRectFillUsingBlendMode(CGRect(x: 0, y: 0, width: f.size.width, height: barHeight), .normal)
            UIRectFillUsingBlendMode(CGRect(x: 0, y: f.size.height - barHeight, width: f.size.width, height: barHeight), .normal)
            let imageOverlay = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            let overlayIV = UIImageView(frame: f)
            overlayIV.image = imageOverlay
            imagePickerController.cameraOverlayView?.addSubview(overlayIV)
        }
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

















