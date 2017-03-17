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
    
    // MARK: - Properties
    var startImage: UIImage!
    
    var context: CIContext!
    var eaglContext: EAGLContext!
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    lazy var hideEditPreviewGesture: UILongPressGestureRecognizer = {
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(handleHideGesture(sender:)))
        gesture.minimumPressDuration = 0.05
        return gesture
    }()
    
    lazy var editFilterManager: FSImageEditFilterManager = {
        return FSImageEditFilterManager(image: self.startImage, context: self.context)
    }()
    
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
    lazy var startingImageView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = self.startImage
        imgView.translatesAutoresizingMaskIntoConstraints = false
        return imgView
    }()
    
    lazy var editingImageView: CIImageView = {
        let imgView = CIImageView(eaglContext: self.eaglContext, ciContext: self.context)
        imgView.image = CIImage(image: self.startImage)
        imgView.addGestureRecognizer(self.hideEditPreviewGesture)
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
    
    convenience init(image: UIImage, context: CIContext, eaglContext: EAGLContext) {
        self.init()
        self.startImage = image
        self.context = context
        self.eaglContext = eaglContext
        
        view.backgroundColor = .white
        sliderMenuTopAnchorConstraint = sliderMenuView.topAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        navigationController!.navigationBar.addSubview(filterIconView)

        // Constraints
        view.addSubview(startingImageView)
        view.addSubview(editingImageView)
        view.addSubview(editToolsController)
        view.addSubview(sliderMenuView)
        
        NSLayoutConstraint.activate([
            startingImageView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor),
            startingImageView.leftAnchor.constraint(equalTo: view.leftAnchor),
            startingImageView.rightAnchor.constraint(equalTo: view.rightAnchor),
            startingImageView.heightAnchor.constraint(equalToConstant: view.frame.width),
            
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
    
    override func viewDidDisappear(_ animated: Bool) {
        filterIconView.isHidden = true
    }

    func handleHideGesture(sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            editingImageView.isHidden = true
        } else if sender.state == .ended {
            editingImageView.isHidden = false
        }
    }
    
    func animateConstraintChanges() {
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
}
// MARK: - FSImageEditViewDelegate
extension FSImageEditCoordinator: FSImageEditViewDelegate {
    // TODO: Remove individual slider moving methods and roll into one method that accepts the sender and the type.
    func brightnessSliderMove(sender: UISlider) {
        // TODO
        let outputImage = editFilterManager.editedInputImage(filter: .brightness, rawValue: sender.value)
        DispatchQueue.main.async {
            self.editingImageView.image = outputImage
        }
    }
    func contrastSliderMove(sender: UISlider) {
        // TODO
        let outputImage = editFilterManager.editedInputImage(filter: .contrast, rawValue: sender.value)
        DispatchQueue.main.async {
            self.editingImageView.image = outputImage
        }
    }
    func structureSliderMove(sender: UISlider) {
        // TODO
        let outputImage = editFilterManager.editedInputImage(filter: .structure, rawValue: sender.value)
        DispatchQueue.main.async {
            self.editingImageView.image = outputImage
        }
    }
    
    func warmthSliderMove(sender: UISlider) {
        // TODO
        let outputImage = editFilterManager.editedInputImage(filter: .warmth, rawValue: sender.value)
        DispatchQueue.main.async {
            self.editingImageView.image = outputImage
        }
    }
    
    func saturationSliderMove(sender: UISlider) {
        // todo
        let outputImage = editFilterManager.editedInputImage(filter: .saturation, rawValue: sender.value)
        DispatchQueue.main.async {
            self.editingImageView.image = outputImage
        }
    }
    
    func highlightsSliderMove(sender: UISlider) {
        // todo
    }
    
    func shadowsSliderMove(sender: UISlider) {
        //
    }
    
    func vignetteSliderMove(sender: UISlider) {
        //
    }
    
    func tiltShiftChanged(mode: TiltShiftMode) {
        //
    }
    
    func sliderViewDidAppear(type: FSImageAdjustmentType) {
        // Present Cancel and Done overlay for bottom buttons
        // Change nav bar title
        self.title = type.stringRepresentation
        sliderMenuTopAnchorConstraint.constant = -48
        sliderMenuView.activeSlider = type
        animateConstraintChanges()
        navigationItem.setHidesBackButton(true, animated: false)
        filterIconView.isHidden = true
    }
    
    func sliderViewDidDisappear() {
        // Change nav bar title
        self.title = nil
        navigationItem.setHidesBackButton(false, animated: false)
        filterIconView.isHidden = false
        // Set new input image on edit filter manager
//        editFilterManager.inputImage = editingImageView.image!
    }
    
}

// MARK: - FSSliderMenuViewDelegate
extension FSImageEditCoordinator: FSImageSliderMenuViewDelegate {
    func cancelButtonTapped(type: FSImageAdjustmentType) {
        // Cancel button was tapped. Reset active slider to lastValue
        editToolsController.resetSlider()
        // Notify filter manager to reset stored value to lastValue
        // Animate hiding the FSImageSliderMenuView
        sliderMenuTopAnchorConstraint.constant = 0
        animateConstraintChanges()
    }
    
    func doneButtonTapped(type: FSImageAdjustmentType) {
        // Done button was tapped. Set active slider's lastValue to it's currentValue
        // Animate hiding the FSImageSliderMenuView
        editToolsController.saveSlider()
        sliderMenuTopAnchorConstraint.constant = 0
        animateConstraintChanges()
        // Notify the filter manager to store the current value
        editFilterManager.updateStoredValue(forType: type)
    }
}
