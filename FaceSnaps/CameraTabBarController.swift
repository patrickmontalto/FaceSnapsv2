//
//  CameraTabBarController.swift
//  FaceSnaps
//
//  Created by Patrick Montalto on 1/12/17.
//  Copyright © 2017 Patrick Montalto. All rights reserved.
//

import UIKit

class CameraTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Appearance
        UITabBar.appearance().tintColor = .black
        UITabBarItem.appearance().setTitleTextAttributes([NSFontAttributeName: UIFont.systemFont(ofSize: 16.0, weight: UIFontWeightMedium)], for: .normal)
        automaticallyAdjustsScrollViewInsets = false
        
        delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Library
        let libraryTab = FSLibraryImagePickerController()
        libraryTab.delegate = self
        let libraryTabBarItem = UITabBarItem(title: "Library", image: nil, tag: 0)
        libraryTabBarItem.titlePositionAdjustment = UIOffsetMake(0, -12)
        libraryTab.tabBarItem  = libraryTabBarItem
    
        
        // Photo
        let photoTab = FSImagePickerController()
        photoTab.delegate = self
        let photoTabBarItem = UITabBarItem(title: "Photo", image: nil, tag: 1)
        photoTabBarItem.titlePositionAdjustment = UIOffsetMake(0, -12)
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
