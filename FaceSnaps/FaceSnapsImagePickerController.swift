//
//  FaceSnapsImagePickerController.swift
//  FaceSnaps
//
//  Created by Patrick Montalto on 12/29/16.
//  Copyright © 2016 Patrick Montalto. All rights reserved.
//

import UIKit
import AVFoundation

class FaceSnapsImagePickerController: UIViewController {
    
    weak var delegate: FaceSnapsImagePickerController?
    
    // MARK: Top Navigation / Title bar
    lazy var navigationBar: UINavigationBar = {
        let navBar = UINavigationBar()
        navBar.tintColor = .lightGray
        
        let navItem = UINavigationItem(title: "Photo")
        // TODO: Add cancel action (go back)
        let cancelBarButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        cancelBarButton.tintColor = .black
        
        navItem.leftBarButtonItem = cancelBarButton

        navBar.items = [navItem]
        
        return navBar
    }()
    
    // MARK: Frame for capture
    lazy var frameForCapture: UIView = {
        let view = UIView()
        
        return view
    }()
    
    // MARK: Captured Image (for test)
    lazy var imageView: UIImageView = {
        let imgView = UIImageView()
        
        return imgView
    }()
    
    // MARK: Take Photo button
    lazy var takePhotoButton: UIButton = {
        let button = UIButton()
        
        return button
    }()
    
    // MARK: Flip camera button
    lazy var flipCameraButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("Flip Camera", for: .normal)
        button.addTarget(self, action: #selector(FaceSnapsImagePickerController.flipCameraPressed(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    // MARK: Toggle flash modes
    lazy var toggleFlashModesButton: UIButton = {
        let button = UIButton()
        let flashOff = UIImage(named: "flash_off")!
        button.setImage(flashOff, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
//        button.setImage(image: flashOff, inFrame: CGRect(x: 0, y: 0, width: 32, height: 32), forState: .normal)
        
        button.addTarget(self, action: #selector(FaceSnapsImagePickerController.toggleFlashPressed(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    // MARK: AV Capture Variables
    
    lazy var session: AVCaptureSession = {
        let avcSession = AVCaptureSession()
        // Set Capture Settings
        avcSession.sessionPreset = AVCaptureSessionPresetPhoto

        do {
            let deviceInput = try AVCaptureDeviceInput(device: self.inputDevice)
            
            if avcSession.canAddInput(deviceInput) {
                avcSession.addInput(deviceInput)
            }

        } catch let error as NSError {
            print(error.localizedDescription)
            return avcSession
        }
    
        avcSession.addOutput(self.stillImageOutput)
        
        return avcSession
    }()
    
    lazy var inputDevice: AVCaptureDevice = {
        // Create AVCaptureDevice (our front camera by default)
        let device = AVCaptureDevice.defaultDevice(withDeviceType: .builtInWideAngleCamera, mediaType: AVMediaTypeVideo, position: .front)
        
        return device!
    }()
    
    lazy var previewLayer: AVCaptureVideoPreviewLayer = {
        guard let previewLayer = AVCaptureVideoPreviewLayer(session: self.session) else {
            print("Error generating AVCaptureVideoPreviewLayer")
            return AVCaptureVideoPreviewLayer()
        }
        previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        return previewLayer
    }()
    
    // TODO: Update for iOS 10
    lazy var stillImageOutput: AVCaptureStillImageOutput = {
        let output = AVCaptureStillImageOutput()
        let outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]
        
        output.outputSettings = outputSettings
        return output
    }()
    
    func setFrameForCapture() {
        self.view.layer.masksToBounds = true
        let frame = self.frameForCapture.frame
        previewLayer.frame = frame
        
        self.view.layer.insertSublayer(previewLayer, at: 0)
    }
    
    // Hide status bar
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func takePhoto(sender: UIButton) {
        // TODO: Implement
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Photo"
        
        takePhotoButton.addTarget(self, action: #selector(FaceSnapsImagePickerController.takePhoto(sender:)), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        session.startRunning()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        view.addSubview(navigationBar)
        view.addSubview(frameForCapture)
        view.addSubview(flipCameraButton)
        view.addSubview(toggleFlashModesButton)
        
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        frameForCapture.translatesAutoresizingMaskIntoConstraints = false
        flipCameraButton.translatesAutoresizingMaskIntoConstraints = false
        toggleFlashModesButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            navigationBar.topAnchor.constraint(equalTo: view.topAnchor),
            navigationBar.leftAnchor.constraint(equalTo: view.leftAnchor),
            navigationBar.rightAnchor.constraint(equalTo: view.rightAnchor),
            navigationBar.heightAnchor.constraint(equalToConstant: 44),
            
            // Add everthing else
            frameForCapture.topAnchor.constraint(equalTo: navigationBar.bottomAnchor),
            frameForCapture.leftAnchor.constraint(equalTo: view.leftAnchor),
            frameForCapture.rightAnchor.constraint(equalTo: view.rightAnchor),
            frameForCapture.heightAnchor.constraint(equalTo: frameForCapture.widthAnchor, multiplier: 0.890667),
            
            flipCameraButton.bottomAnchor.constraint(equalTo: frameForCapture.bottomAnchor, constant: -8),
            flipCameraButton.leftAnchor.constraint(equalTo: frameForCapture.leftAnchor, constant: 8),
            
            toggleFlashModesButton.rightAnchor.constraint(equalTo: frameForCapture.rightAnchor, constant: -8),
            toggleFlashModesButton.bottomAnchor.constraint(equalTo: frameForCapture.bottomAnchor, constant: -8),
            toggleFlashModesButton.widthAnchor.constraint(equalToConstant: 32),
        ])
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setFrameForCapture()
    }
    
    // MARK: Flip the camera (to rear or back to front) 
    func flipCameraPressed(sender: UIButton) {
        // Stop running the session
        session.stopRunning()
        
        // Get current position
        let position = (session.inputs!.first! as! AVCaptureDeviceInput).device.position
        var newPosition: AVCaptureDevicePosition
        
        // Create a new capture sessiojn
        session = AVCaptureSession()
        // Set Capture Settings
        session.sessionPreset = AVCaptureSessionPresetPhoto
        
        // Determine which will ne the new Position
        if position == AVCaptureDevicePosition.front {
            newPosition = .back
        } else {
            newPosition = .front
        }
        
        // Create a new input device with the new position
        inputDevice = AVCaptureDevice.defaultDevice(withDeviceType: .builtInWideAngleCamera, mediaType: AVMediaTypeVideo, position: newPosition)
        
        // Remove previewLayer
        previewLayer.removeFromSuperlayer()
        
        // Set the new device for the session
        do {
            let deviceInput = try AVCaptureDeviceInput(device: inputDevice)
            
            if session.canAddInput(deviceInput) {
                session.addInput(deviceInput)
            }
            
        } catch let error as NSError {
            print(error.localizedDescription)
            return
        }
        
        // Reload the previewLayer with the new session
        reloadPreviewLayer()
        
        // Set up the new previewLayer's frame
        setFrameForCapture()
        
        // Start the new session
        session.startRunning()
    }
    
    private func reloadPreviewLayer() {
        guard let newPreviewLayer = AVCaptureVideoPreviewLayer(session: self.session) else {
            print("Error generating AVCaptureVideoPreviewLayer")
            return
        }
        newPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        
        // Set new previewLayer
        previewLayer = newPreviewLayer
    }
    
    // MARK: Toggle flash modes
    func toggleFlashPressed(sender: UIButton) {
        // Check if the device has flash
        if inputDevice.hasFlash {
            do {
                // Lock device for configuration
                try inputDevice.lockForConfiguration()
                // Determine current flashMode and set the next one
                let currentFlashMode = inputDevice.flashMode
                if currentFlashMode == .off {
                    setFlashMode(flashMode: .on)
                } else if currentFlashMode == .on {
                    setFlashMode(flashMode: .auto)
                } else {
                    setFlashMode(flashMode: .off)
                }
                // Unlock the device
                inputDevice.unlockForConfiguration()
                
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }
    
    private func setFlashMode(flashMode: AVCaptureFlashMode) {
        // TODO: Update for iOS 10
        inputDevice.flashMode = flashMode
        // Set new image for flashMode button
        var flashModeImage = UIImage()
        switch flashMode {
        case .auto:
            flashModeImage = UIImage(named: "flash_auto")!
        case .on:
            flashModeImage = UIImage(named: "flash_on")!
        case .off:
            flashModeImage = UIImage(named: "flash_off")!
        }
        
        toggleFlashModesButton.setImage(flashModeImage, for: .normal)
    }
    
}

// MARK: FaceSnapsImagePickerControllerDelegate
protocol FaceSnapsImagePickerControllerDelegate {
    func imagePickerController(_ picker: FaceSnapsImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
}







