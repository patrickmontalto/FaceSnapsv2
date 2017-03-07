//
//  CameraTabBarController.swift
//  FaceSnaps
//
//  Created by Patrick Montalto on 1/12/17.
//  Copyright © 2017 Patrick Montalto. All rights reserved.
//

import UIKit

class CameraTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    var parentController: ImagePickerNavigationController!
    
    convenience init(parentController: ImagePickerNavigationController) {
        self.init()
        self.parentController = parentController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
        UITabBar.appearance().tintColor = .black
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Library
        let libraryTab = FSLibraryImagePickerController()
        libraryTab.delegate = self
        let libraryTabBarItem = UITabBarItem(title: "Library", image: nil, tag: 0)
        libraryTab.tabBarItem  = libraryTabBarItem
        
        // Photo
        let photoTab = FSImagePickerController()
        photoTab.delegate = self
        let photoTabBarItem = UITabBarItem(title: "Photo", image: nil, tag: 1)
        photoTab.tabBarItem = photoTabBarItem
        
        // Set view controllers
        viewControllers = [libraryTab, photoTab]
        
        // Add cancel button
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(dismissView))
    }
    
    func dismissView() {
        dismiss(animated: true, completion: nil)
    }

}

// MARK: - FSLibaryImagePickerControllerDelegate
extension CameraTabBarController: FSLibraryImagePickerControllerDelegate {
    
    
    func libraryImagePickerController(_ picker: FSLibraryImagePickerController, didFinishPickingImage image: UIImage) {
        // TODO: Get notified from FSLibraryImagePickerController that next button was tapped
        // Get image and present image editing controller via navigation controller
    }
    func cameraRollAccessDenied() {
        // TODO
    }
    func cameraRollAccessAllowed() {
        // TODO
    }
    
    func getCropHeightRatio() -> CGFloat {
        // TODO
        return 0
    }
}

// MARK: - FSImagePickerControllerDelegate
extension CameraTabBarController: FSImagePickerControllerDelegate {
    func imagePickerController(_ picker: FSImagePickerController, didFinishPickingImage image: UIImage) {
        // TODO:
        // get image and move on to the image editing controller via navigiation controller
    }
}
