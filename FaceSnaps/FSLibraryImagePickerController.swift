//
//  FSLibraryImagePickerController.swift
//  FaceSnaps
//
//  Created by Patrick Montalto on 3/5/17.
//  Copyright © 2017 Patrick Montalto. All rights reserved.
//

import UIKit
import Photos

class FSLibraryImagePickerController: UIViewController {
    var delegate: FSLibraryImagePickerControllerDelegate?
    
    lazy var collectionView: UICollectionView = {
        let cvLayout = UICollectionViewFlowLayout()
        let width = (self.view.frame.width - 3) / 4
        cvLayout.itemSize = CGSize(width: width, height: width)
        cvLayout.minimumInteritemSpacing = 1
        cvLayout.minimumLineSpacing = 1
        let cv = UICollectionView(frame: .zero, collectionViewLayout: cvLayout)
        cv.delegate = self
        cv.dataSource = self
        cv.allowsSelection = true
        cv.backgroundColor = .white
        let cellNib = UINib(nibName: "FSLibraryViewCell", bundle: nil)
        cv.register(cellNib, forCellWithReuseIdentifier: "FSLibraryViewCell")
        return cv
    }()
    
    var selectedImageViewContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()

    lazy var selectedImageView: FSImageCropView = {
        return FSImageCropView()
    }()
    
    var collectionViewConstraintHeight: NSLayoutConstraint!
    var selectedImageViewConstraintTopAnchor: NSLayoutConstraint!
    
    lazy var initialCollectionViewHeightConstant: CGFloat = {
        let tabBarHeight: CGFloat = 49.0
        return self.view.frame.height - self.view.frame.width - tabBarHeight - (self.navigationController?.navigationBar.frame.height ?? 0)
    }()
    
    var selectedAsset: PHAsset? {
        guard let selectedIndex = self.collectionView.indexPathsForSelectedItems?.first else { return nil }
        return images[selectedIndex.row]
    }
    
    var selectedImageViewIsHidden: Bool {
        return self.selectedImageViewConstraintTopAnchor.constant == -self.selectedImageViewContainer.frame.height + 40
    }
    
    var selectedImageViewShouldScrollUp: Bool {
        if self.selectedImageViewIsHidden { return false }
        return self.selectedImageViewConstraintTopAnchor.constant < -40
    }
    
    let initialSelectedImageViewTopConstant: CGFloat = 0
    var images = [PHAsset]()
    var imageManager = PHCachingImageManager()
    var cellSize = CGSize(width: 100, height: 100)
    
    /// Holds the starting point for a new pan
    var dragStartPos: CGPoint = .zero
    /// Whether the selectedImageViewContainer is currently raised or being risen
    var viewDidRaise = false
    /// Determines if the view will go down
    var viewWillLower = false
    
    lazy var gesture: UIPanGestureRecognizer = {
        let gstr = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        gstr.delegate = self
        return gstr
    }()
    
    // Variables for calculating position
    enum Direction {
        case scroll, stop, up, down
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        PHPhotoLibrary.shared().register(self)
        
        if PHPhotoLibrary.authorizationStatus() == .authorized {
            initializeUserInterface()
        } else {
            requestAuthorizationWithRedirectionToSettings()
        }
    }
    

    // Hide the status bar
    override var prefersStatusBarHidden: Bool {
        return true
    }

    func requestAuthorizationWithRedirectionToSettings() {
        DispatchQueue.main.async {
            let status = PHPhotoLibrary.authorizationStatus()
            if status == .authorized {
                self.initializeUserInterface()
            } else {
                // No permission granted. Trying to normally request it.
                PHPhotoLibrary.requestAuthorization({ (authStatus) in
                    if authStatus != .authorized {
                        // User did not give permission. Showing alert with redirection to settings.
                        // Getting description string from info.plist file
                        let accessDescription = Bundle.main.object(forInfoDictionaryKey: "NSPhotoLibraryUsageDescription") as! String
                        let alertController = UIAlertController(title: accessDescription, message: "To give permissions tap on 'Change Settings' button", preferredStyle: .alert)
                        
                        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
                            self.dismiss(animated: true, completion: nil)
                        })
                        alertController.addAction(cancelAction)
                        
                        let settingsAction = UIAlertAction(title: "Change Settings", style: .default, handler: { (action) in
                            let settingsURL = URL(string: UIApplicationOpenSettingsURLString)!
                            UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
                        })
                        alertController.addAction(settingsAction)
                                            
                        self.present(alertController, animated: true, completion: nil)
                    }
                })
            }
        }
    }
    
    fileprivate func initializeUserInterface() {
        // View hierarchies
        view.addSubview(collectionView)
        view.addSubview(selectedImageViewContainer)
        selectedImageViewContainer.addSubview(selectedImageView)
        
        automaticallyAdjustsScrollViewInsets = false

        
        // Constraints
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        selectedImageViewContainer.translatesAutoresizingMaskIntoConstraints = false
        selectedImageView.translatesAutoresizingMaskIntoConstraints = false
        
        // Initial values
        collectionViewConstraintHeight = NSLayoutConstraint(item: collectionView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: initialCollectionViewHeightConstant)
        
         selectedImageViewConstraintTopAnchor = NSLayoutConstraint(item: selectedImageViewContainer, attribute: .top, relatedBy: .equal, toItem: topLayoutGuide, attribute: .bottom, multiplier: 1.0, constant: initialSelectedImageViewTopConstant)
        
        collectionViewConstraintHeight.constant = view.frame.height - view.frame.width - selectedImageViewConstraintTopAnchor.constant - 49 - (self.navigationController?.navigationBar.frame.height ?? 0)
        
        
        NSLayoutConstraint.activate([
            selectedImageViewConstraintTopAnchor,
            selectedImageViewContainer.leftAnchor.constraint(equalTo: view.leftAnchor),
            selectedImageViewContainer.rightAnchor.constraint(equalTo: view.rightAnchor),
            selectedImageViewContainer.heightAnchor.constraint(equalToConstant: view.frame.width),
            
            selectedImageView.topAnchor.constraint(equalTo: selectedImageViewContainer.topAnchor),
            selectedImageView.leftAnchor.constraint(equalTo: selectedImageViewContainer.leftAnchor),
            selectedImageView.rightAnchor.constraint(equalTo: selectedImageViewContainer.rightAnchor),
            selectedImageView.bottomAnchor.constraint(equalTo: selectedImageViewContainer.bottomAnchor),
            
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor),
            collectionViewConstraintHeight,
        ])
        
        // Set gesture
        view.addGestureRecognizer(gesture)
        // Add tap gesture
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tappedView(_:)))
        selectedImageViewContainer.addGestureRecognizer(tapGesture)
        
        // Get data from library
        let options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        options
        let results = PHAsset.fetchAssets(with: .image, options: options)
        results.enumerateObjects({ (obj, idx, stop) in
            self.images.append(obj)
        })
        
        imageManager.startCachingImages(for: images, targetSize: cellSize, contentMode: .aspectFill, options: nil)
        collectionView.reloadData()
        
        // Select first item
        selectFirstItem()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Add next button
        tabBarController?.navigationItem.rightBarButtonItem =  UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(selectedImage))
    }
    
    func selectFirstItem() {
        guard images.count > 0 else { return }
        let indexPath = IndexPath(item: 0, section: 0)
        collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .top)
        guard let asset = images.first else { return }
        populateImageView(withAsset: asset)
    }

    func selectedImage() {
        // TODO: get cropped image and notify delegate
        guard let selectedAsset = selectedAsset else { return }

        ImageCropHelper.cropToImageCropView(selectedImageView, asset: selectedAsset, cropHeightRatio: delegate!.getCropHeightRatio()) { (image) in
            guard let image = image else { return }
            self.delegate!.libraryImagePickerController(self, didFinishPickingImage: image)
        }
    }

    deinit {
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
    }
    
    func tappedView(_ recognizer: UITapGestureRecognizer) {
        if selectedImageViewIsHidden {
            resetSlidingViewConstraints()
            animateConstraintChanges()
        }
    }
    
    /// Determines behavior of selectedImageView scrolling
    func handlePanGesture(_ recognizer: UIPanGestureRecognizer) {
        let selectedImageViewBottomY = selectedImageViewContainer.frame.origin.y + selectedImageViewContainer.frame.height
        let dragPos = recognizer.location(in: self.view)
        let velocity = recognizer.velocity(in: self.view)

        switch recognizer.state {
        case .began:
            dragStartPos = recognizer.location(in: self.view)
        case .changed:
            
            // Selected image view is hidden and top of collection view is reached.
            if collectionView.contentOffset.y < 0 && selectedImageViewIsHidden {
                viewWillLower = true
                // Constrain selectedImageView bottom to top of collectionView 
                // So that it may be dragged when scrolling
            }
            
            // Calculate the difference above the bottom Y of the selectedImageViewContainer
            let difference = selectedImageViewBottomY - dragPos.y
            
            if collectionView.frame.contains(dragStartPos) && !selectedImageViewIsHidden {
                if selectedImageViewContainer.frame.contains(dragPos) {
                    if velocity.y < 0 { // Moving up
//                        print("Sliding it up!")

                        viewDidRaise = true
                        // Gradually move up the selectedImageViewContainer
                        selectedImageViewConstraintTopAnchor.constant -= difference
                        // Increase the height of the collectionView
                        collectionViewConstraintHeight.constant += difference
                    }
                } else if viewDidRaise && velocity.y > 0 {
                    // View is currently being slid up. Allow it to be dragged down
                
                    if selectedImageViewConstraintTopAnchor.constant < initialSelectedImageViewTopConstant {
//                        print("sliding it down!")

                        // Gradually move down the selectedImageViewContainer
                        selectedImageViewConstraintTopAnchor.constant -= difference
                        // Decrease the height of the collectionView
                        collectionViewConstraintHeight.constant += difference
                    }
                }
                animateConstraintChanges()

            }

        case .ended:
            // Image view was scrolled up when touch began, and then pulled down when collectionView scroll reached top
            // Pull the selectedImageView down
            if viewWillLower {
                resetSlidingViewConstraints()
            } else if selectedImageViewShouldScrollUp {
                // Slide it up to the top
                selectedImageViewConstraintTopAnchor.constant = -selectedImageViewContainer.frame.height + 40
                collectionViewConstraintHeight.constant = view.frame.height - bottomLayoutGuide.length - self.navigationController!.navigationBar.frame.height - 40
            }
            animateConstraintChanges()
            viewWillLower = false
        default:
            break
        }
//        print("The beginning pos was: \(dragStartPos)")
    }
    
    private func resetSlidingViewConstraints() {
        viewDidRaise = false
        selectedImageViewConstraintTopAnchor.constant = initialSelectedImageViewTopConstant
        collectionViewConstraintHeight.constant = initialCollectionViewHeightConstant
    }
    
    private func animateConstraintChanges() {
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    /// Populate the selectedImageView with the selected thumbnail asset
    func populateImageView(withAsset asset: PHAsset) {
        let options = PHImageRequestOptions()
        options.deliveryMode = .opportunistic
        let targetSize = CGSize(width: asset.pixelWidth, height: asset.pixelHeight)
        imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFill, options: options) { (image, info) in
            self.selectedImageView.image = image
        }
    }
}

// MARK: - UIGestureRecognizerDelegate
extension FSLibraryImagePickerController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

// MARK: - UICollectionViewDataSource & UICollectionViewDelegate
extension FSLibraryImagePickerController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FSLibraryViewCell", for: indexPath) as! FSLibraryViewCell
        
        let asset = images[indexPath.row]
        imageManager.requestImage(for: asset, targetSize: cellSize, contentMode: .aspectFill, options: nil) { (image, info) in
            cell.imageView.contentMode = .scaleAspectFill
            cell.image = image
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let asset = images[indexPath.row]
        populateImageView(withAsset: asset)
    }
}

// MARK: - PHPhotoLibraryChangeObserver
extension FSLibraryImagePickerController: PHPhotoLibraryChangeObserver {
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        // TODO
        if PHPhotoLibrary.authorizationStatus() == .authorized {
            DispatchQueue.main.async { [weak self] in
                self?.initializeUserInterface()
            }
        }
    }
}

// MARK: - UIGestureRecognizerDelegate
//extension FSLibraryImagePickerController: UIGestureRecognizerDelegate {
//    
//}

protocol FSLibraryImagePickerControllerDelegate {
    func libraryImagePickerController(_ picker: FSLibraryImagePickerController, didFinishPickingImage image: UIImage)
    func getCropHeightRatio() -> CGFloat
    
    func cameraRollAccessDenied()
    func cameraRollAccessAllowed()
}

