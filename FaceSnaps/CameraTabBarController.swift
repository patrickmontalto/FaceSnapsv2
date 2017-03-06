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
    }
    
}

// MARK: - FSLibaryImagePickerControllerDelegate
extension CameraTabBarController: FSLibraryImagePickerControllerDelegate {
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
        // TODO
    }
}
