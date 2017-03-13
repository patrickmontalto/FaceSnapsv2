//
//  FSImageEditCoordinator.swift
//  FaceSnaps
//
//  Created by Patrick Montalto on 3/11/17.
//  Copyright © 2017 Patrick Montalto. All rights reserved.
//

import Foundation
import UIKit

/// Coordinator that contains a selected image and a tab bar controlling which editing tools are
/// presented to the user.
class FSImageEditCoordinator: UIViewController {
    
    var image: UIImage!
    
    // TODO: Create an image view that can be manipulated with filters, brightness, etc
    /// Contains the selected image which is currently being manipulated.
    lazy var editingImageView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = self.image
        imgView.translatesAutoresizingMaskIntoConstraints = false
        return imgView
    }()
    
    /// The edit tools controller which holds the two horizontal collectionViews and their slider views
    lazy var editToolsController: FSImageEditToolsController = {
        let controller =  FSImageEditToolsController(coordinator: self, delegate: self)
        controller.translatesAutoresizingMaskIntoConstraints = false
        return controller
    }()
    
    convenience init(image: UIImage) {
        self.init()
        self.image = image
        view.backgroundColor = .white
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        // Constraints
        view.addSubview(editingImageView)
        view.addSubview(editToolsController)
        
        NSLayoutConstraint.activate([
            editingImageView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor),
            editingImageView.leftAnchor.constraint(equalTo: view.leftAnchor),
            editingImageView.rightAnchor.constraint(equalTo: view.rightAnchor),
            editingImageView.heightAnchor.constraint(equalToConstant: view.frame.width),
            
            editToolsController.topAnchor.constraint(equalTo: editingImageView.bottomAnchor),
            editToolsController.leftAnchor.constraint(equalTo: view.leftAnchor),
            editToolsController.rightAnchor.constraint(equalTo: view.rightAnchor),
            editToolsController.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}
// MARK: - FSImageEditViewDelegate
extension FSImageEditCoordinator: FSImageEditViewDelegate {
    func brightnessSliderMove(sender: UISlider) {
        // TODO
    }
    func contrastSliderMove(sender: UISlider) {
        // TODO
    }
    func structureSliderMove(sender: UISlider) {
        // TODO
    }
}
