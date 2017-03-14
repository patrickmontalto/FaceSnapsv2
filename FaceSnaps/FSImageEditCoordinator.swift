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
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    lazy var filterIconView: UIImageView = {
        let image = UIImage(named: "filter_icon")!
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 23, height: 22))
        imageView.center.x = self.navigationController!.view.center.x
        imageView.center.y = self.navigationController!.navigationBar.center.y
        imageView.contentMode = .scaleAspectFit
        imageView.image = image
        
        return imageView
    }()
    
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
    
    /// The Cancel and Done overlay buttons for when an editing tool's slider view is active
    lazy var sliderMenuView: FSImageSliderMenuView = {
        return FSImageSliderMenuView(delegate: self)
    }()
    
    var sliderMenuTopAnchorConstraint = NSLayoutConstraint()
    
    convenience init(image: UIImage) {
        self.init()
        self.image = image
        view.backgroundColor = .white
        sliderMenuTopAnchorConstraint = sliderMenuView.topAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        navigationController!.navigationBar.addSubview(filterIconView)

        // Constraints
        view.addSubview(editingImageView)
        view.addSubview(editToolsController)
        view.addSubview(sliderMenuView)
        
        NSLayoutConstraint.activate([
            editingImageView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor),
            editingImageView.leftAnchor.constraint(equalTo: view.leftAnchor),
            editingImageView.rightAnchor.constraint(equalTo: view.rightAnchor),
            editingImageView.heightAnchor.constraint(equalToConstant: view.frame.width),
            
            editToolsController.topAnchor.constraint(equalTo: editingImageView.bottomAnchor),
            editToolsController.leftAnchor.constraint(equalTo: view.leftAnchor),
            editToolsController.rightAnchor.constraint(equalTo: view.rightAnchor),
            editToolsController.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            sliderMenuView.heightAnchor.constraint(equalToConstant: 48.0),
            sliderMenuView.leftAnchor.constraint(equalTo: view.leftAnchor),
            sliderMenuView.rightAnchor.constraint(equalTo: view.rightAnchor),
            sliderMenuTopAnchorConstraint
        ])
    }

    
    func animateConstraintChanges() {
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
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
    
    func sliderViewDidAppear(type: FSImageSliderType) {
        // Present Cancel and Done overlay for bottom buttons
        // Change nav bar title
        self.title = type.stringRepresentation
        sliderMenuTopAnchorConstraint.constant = -48
        animateConstraintChanges()
        navigationItem.setHidesBackButton(true, animated: false)
        filterIconView.isHidden = true
    }
    
    func sliderViewDidDisappear() {
        // Change nav bar title
        self.title = nil
        navigationItem.setHidesBackButton(false, animated: false)
        filterIconView.isHidden = false
    }
}

// MARK: - FSSliderMenuViewDelegate
extension FSImageEditCoordinator: FSImageSliderMenuViewDelegate {
    func cancelButtonTapped() {
        editToolsController.resetSlider()
        // Cancel button was tapped. Reset active slider to lastValue
        // Animate hiding the FSImageSliderMenuView
        sliderMenuTopAnchorConstraint.constant = 0
        animateConstraintChanges()
    }
    
    func doneButtonTapped() {
        // Done button was tapped. Set active slider's lastValue to it's currentValue
        // Animate hiding the FSImageSliderMenuView
        editToolsController.saveSlider()
        sliderMenuTopAnchorConstraint.constant = 0
        animateConstraintChanges()
    }
}
