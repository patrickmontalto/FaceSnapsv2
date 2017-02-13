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
    
    var delegate: FaceSnapsImagePickerControllerDelegate?
    
    // MARK: Top Navigation / Title bar
    lazy var navigationBar: UINavigationBar = {
        let navBar = UINavigationBar()
        navBar.tintColor = .lightGray
        
        let navItem = UINavigationItem(title: "Photo")
        // TODO: Add cancel action (go back)
        let cancelBarButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(FaceSnapsImagePickerController.dismissImagePicker))
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
    
    // MARK: Focus View (tap to focus)
    var focusView: CameraFocusView?
    
    // MARK: Gesture Recognizer for Focusing
    lazy var focusGesture: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tapToFocus(gesture:)))
        return gesture
    }()
    
    // MARK: Bottom View
    lazy var bottomView: UIView = {
        let view = UIView()
        view.addSubview(self.takePhotoButton)
        view.backgroundColor = .backgroundGray
        return view
    }()
    
    // MARK: Take Photo button
    lazy var takePhotoButton: UIButton = {
        let button = UIButton()
        let shutter = UIImage(named: "shutter_button")!
        button.setImage(shutter, for: .normal)

        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(FaceSnapsImagePickerController.takePhoto(sender:)), for: .touchUpInside)
        return button
    }()
    
    // MARK: Flip camera button
    lazy var flipCameraButton: UIButton = {
        let button = UIButton()
        let flip = UIImage(named: "flip")!
        button.setImage(flip, for: .normal)
        button.showsTouchWhenHighlighted = true
        button.addTarget(self, action: #selector(FaceSnapsImagePickerController.flipCameraPressed(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    // MARK: Toggle flash modes
    lazy var toggleFlashModesButton: UIButton = {
        let button = UIButton()
        let flashOff = UIImage(named: "flash_off")!
        button.setImage(flashOff, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.showsTouchWhenHighlighted = true
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
    
    // Current orientation
    var orientation = UIDevice.current.orientation
    
    func takePhoto(sender: UIButton) {
        // TODO: Implement
        var videoConnection: AVCaptureConnection?
        
        for connection in stillImageOutput.connections as! [AVCaptureConnection] {
            for port in connection.inputPorts as! [AVCaptureInputPort] {
                if port.mediaType == AVMediaTypeVideo {
                    videoConnection = connection
                    break
                }
            }
            if (videoConnection != nil) {
                break
            }
        }
        
        stillImageOutput.captureStillImageAsynchronously(from: videoConnection) { (imageDataSampleBuffer, error) in
            if let imageDataSampleBuffer = imageDataSampleBuffer {
                if let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageDataSampleBuffer) {
                    let image = UIImage(data: imageData)!
                    // dismiss controller and set image as cropped profile image of add photo button on EmailSignUpControllerWithAccount
                    let croppedImage = ImageCropHelper.cropToPreviewLayer(previewLayer: self.previewLayer, originalImage: image)
                    self.delegate?.imagePickerController(self, didFinishPickingImage: croppedImage)
                    self.dismissImagePicker()
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Photo"
        
        view.addGestureRecognizer(focusGesture)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addDeviceOrientationObserver(selector: #selector(deviceDidRotate(notification:)))
        session.startRunning()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        view.addSubview(navigationBar)
        view.addSubview(frameForCapture)
        view.addSubview(flipCameraButton)
        view.addSubview(toggleFlashModesButton)
        view.addSubview(bottomView)
        
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        frameForCapture.translatesAutoresizingMaskIntoConstraints = false
        flipCameraButton.translatesAutoresizingMaskIntoConstraints = false
        toggleFlashModesButton.translatesAutoresizingMaskIntoConstraints = false
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        
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
            
            flipCameraButton.bottomAnchor.constraint(equalTo: frameForCapture.bottomAnchor, constant: -12),
            flipCameraButton.leftAnchor.constraint(equalTo: frameForCapture.leftAnchor, constant: 12),
            
            toggleFlashModesButton.rightAnchor.constraint(equalTo: frameForCapture.rightAnchor, constant: -12),
            toggleFlashModesButton.bottomAnchor.constraint(equalTo: frameForCapture.bottomAnchor, constant: -12),
            toggleFlashModesButton.widthAnchor.constraint(equalToConstant: 32),
            
            bottomView.topAnchor.constraint(equalTo: frameForCapture.bottomAnchor),
            bottomView.leftAnchor.constraint(equalTo: view.leftAnchor),
            bottomView.rightAnchor.constraint(equalTo: view.rightAnchor),
            bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            takePhotoButton.centerXAnchor.constraint(equalTo: bottomView.centerXAnchor),
            takePhotoButton.centerYAnchor.constraint(equalTo: bottomView.centerYAnchor),
        ])
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setFrameForCapture()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        removeDeviceOrientationObserver()
    }
    
    // MARK: Flip the camera (to rear or back to front) 
    func flipCameraPressed(sender: UIButton) {
        // Stop running the session
        session.stopRunning()
        
        // Get current position
        let position = (session.inputs!.first! as! AVCaptureDeviceInput).device.position
        var newPosition: AVCaptureDevicePosition
        
        session.removeOutput(stillImageOutput)
        
        // Create a new capture sessiojn
        session = AVCaptureSession()
        // Set Capture Settings
        session.sessionPreset = AVCaptureSessionPresetPhoto
        
        // Determine which will be the new Position
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
        
        
        // TODO: Have to create a new object in memory here otherwise it will crash when we try to assign it to the new session. Need to update to iOS 10 camera API
        stillImageOutput = AVCaptureStillImageOutput()
        stillImageOutput.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]
        
        // Add stillImageOutput
        session.addOutput(self.stillImageOutput)

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
    
    // MARK: Dismiss ImagePicker
    func dismissImagePicker() {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: Tap to focus
    func tapToFocus(gesture: UITapGestureRecognizer) {
        let touchPoint = gesture.location(in: frameForCapture)

        if (focusView != nil) {
            focusView?.updatePoint(touchPoint)
        } else {
            focusView = CameraFocusView(touchPoint: touchPoint)
            frameForCapture.addSubview(focusView!)
            focusView!.setNeedsDisplay()
        }
        
        focusView?.animateFocusingAction()
        
        let convertedPoint = previewLayer.captureDevicePointOfInterest(for: touchPoint)

        do {
            try inputDevice.lockForConfiguration()
            
            /*
             Setting (focus/exposure)PointOfInterest alone does not initiate a (focus/exposure) operation.
             Call set(Focus/Exposure)Mode() to apply the new point of interest.
             */
            if inputDevice.isFocusPointOfInterestSupported && inputDevice.isFocusModeSupported(.autoFocus) {
                inputDevice.focusPointOfInterest = convertedPoint
                inputDevice.focusMode = .autoFocus
            }
            
            if inputDevice.isExposurePointOfInterestSupported && inputDevice.isExposureModeSupported(.autoExpose) {
                inputDevice.exposurePointOfInterest = convertedPoint
                inputDevice.exposureMode = .autoExpose
            }
            
            inputDevice.isSubjectAreaChangeMonitoringEnabled = true
            inputDevice.unlockForConfiguration()
        } catch {
            print("Could not lock device for configuration: \(error)")
        }
    }
    
    // MARK: Rotate flip and flash icons when device rotates
    // TODO: Figure out why rotation doesn't match up to expected results
    func deviceDidRotate(notification: NSNotification) {
//        let currentOrientation = UIDevice.current.orientation
//        
//        switch (orientation, UIDevice.current.orientation) {
//        case (UIDeviceOrientation.portrait, .landscapeLeft):
//            // Rotate 90 CCW
//            rotateCameraControls(angle: CGFloat.pi / 2.0)
//        case (UIDeviceOrientation.portrait, .landscapeRight):
//            // Rotate 90 CW
//            rotateCameraControls(angle: -CGFloat.pi / 2.0)
//        case (UIDeviceOrientation.portrait, .portraitUpsideDown):
//            // Rotate 180 CW
//            rotateCameraControls(angle: -CGFloat.pi)
//        case (UIDeviceOrientation.landscapeRight, .portrait):
//            // Rotate 90 CCW
//            rotateCameraControls(angle: CGFloat.pi / 2.0)
//        case (UIDeviceOrientation.landscapeRight, .landscapeLeft):
//            // Rotate 180 CCW
//            rotateCameraControls(angle: CGFloat.pi)
//        case (UIDeviceOrientation.landscapeRight, .portraitUpsideDown):
//            //Rotate 90 CW
//            rotateCameraControls(angle: -CGFloat.pi / 2.0)
//        case (UIDeviceOrientation.landscapeLeft, .portrait):
//            // 90 CW
//            let angle = -CGFloat.pi / 2
//            rotateCameraControls(angle: angle)
//        case (UIDeviceOrientation.landscapeLeft, .landscapeRight):
//            // 180 CW
//            rotateCameraControls(angle: CGFloat.pi)
//        case (UIDeviceOrientation.landscapeLeft, .portraitUpsideDown):
//            // 90 CCW
//            rotateCameraControls(angle: CGFloat.pi / 2.0)
//        case (UIDeviceOrientation.portraitUpsideDown, .landscapeLeft):
//            // 90 CCW
//            rotateCameraControls(angle: CGFloat.pi / 2.0)
//        case (UIDeviceOrientation.portraitUpsideDown, .portrait):
//            // 180 CCW
//            rotateCameraControls(angle: CGFloat.pi)
//        case (UIDeviceOrientation.portraitUpsideDown, .landscapeRight):
//            // 90 CW
//            rotateCameraControls(angle: -CGFloat.pi / 2.0)
//        default:
//            break
//        }
//        
//        orientation = currentOrientation
    }

    private func rotateCameraControls(angle: CGFloat) {
        UIView.animate(withDuration: 0.5) { 
            self.flipCameraButton.transform = CGAffineTransform(rotationAngle: angle)
            self.toggleFlashModesButton.transform = CGAffineTransform(rotationAngle: angle)
        }
    }
}

// MARK: FaceSnapsImagePickerControllerDelegate
@objc protocol FaceSnapsImagePickerControllerDelegate: class {
    func imagePickerController(_ picker: FaceSnapsImagePickerController, didFinishPickingImage image: UIImage)
    
    @objc optional func imagePickerController(_ picker: FaceSnapsImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
}







