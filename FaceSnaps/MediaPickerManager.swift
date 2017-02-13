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
    }
    
    // Present the Image Picker Controller (attached to the MediaPickerManager) on the presenting View Controller.
    func presentImagePickerController(animated: Bool, withSourceType sourceType: UIImagePickerControllerSourceType) {
        
        imagePickerController.sourceType = .photoLibrary
        
        presentingViewController.present(imagePickerController, animated: animated
            , completion: nil)
    }
    
    func dismissImagePickerController(animated: Bool, completion: @escaping (() -> Void)) {
        imagePickerController.dismiss(animated: animated, completion: completion)
    }

}

extension MediaPickerManager: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        // Pass image to our delegate
        delegate?.mediaPickerManager(manager: self, didFinishPickingImage: image)
    }
}










