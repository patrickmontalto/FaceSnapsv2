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

        let cellNib = UINib(nibName: "FSLibraryViewCell", bundle: nil)
        cv.register(cellNib, forCellWithReuseIdentifier: "FSLibraryViewCell")
        return cv
    }()
    
    var selectedImageViewContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .blue
        return view
    }()

    lazy var selectedImageView: FSImageCropView = {
        return FSImageCropView()
    }()
    
    var collectionViewConstraintHeight: NSLayoutConstraint!
    var selectedImageViewConstraintTopAnchor: NSLayoutConstraint!
    
    let initialCollectionViewHeightConstant: CGFloat = 150
    
    var images = [PHAsset]()
    var imageManager = PHCachingImageManager()
    var cellSize = CGSize(width: 100, height: 100)
    
    var gesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
    
    // Variables for calculating position
    enum Direction {
        case scroll, stop, up, down
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        PHPhotoLibrary.shared().register(self)
        
        if PHPhotoLibrary.authorizationStatus() == .authorized {
            initializeUserInterface()
        } else {
            PHPhotoLibrary.requestAuthorization(requestAuthorizationHandler)
        }
    }
    
    func requestAuthorizationHandler(status: PHAuthorizationStatus) {
        if PHPhotoLibrary.authorizationStatus() == .authorized {
            DispatchQueue.main.async {
                self.initializeUserInterface()
            }
        } else {
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    private func initializeUserInterface() {
        // View hierarchies
        view.addSubview(collectionView)
        view.addSubview(selectedImageViewContainer)
        selectedImageViewContainer.addSubview(selectedImageView)
        
        // Constraints
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        selectedImageViewContainer.translatesAutoresizingMaskIntoConstraints = false
        selectedImageView.translatesAutoresizingMaskIntoConstraints = false
        
        // Initial values
        collectionViewConstraintHeight = NSLayoutConstraint(item: collectionView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: initialCollectionViewHeightConstant)
        
         selectedImageViewConstraintTopAnchor = NSLayoutConstraint(item: selectedImageViewContainer, attribute: .top, relatedBy: .equal, toItem: topLayoutGuide, attribute: .bottom, multiplier: 1.0, constant: 50)
        
        collectionViewConstraintHeight.constant = view.frame.height - view.frame.width - selectedImageViewConstraintTopAnchor.constant - 49 - (self.navigationController?.navigationBar.frame.height ?? 0) - 20
        
        
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
        
        // Get data from library
        let options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        let results = PHAsset.fetchAssets(with: .image, options: options)
        results.enumerateObjects({ (obj, idx, stop) in
            self.images.append(obj)
        })
        
        imageManager.startCachingImages(for: images, targetSize: cellSize, contentMode: .aspectFit, options: nil)
        collectionView.reloadData()
    }

    deinit {
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
    }
    
    func handlePanGesture(_ recognizer: UIPanGestureRecognizer) {
        let dragStartPos = recognizer.location(in: self.view)
        
        switch recognizer.state {
        case .began, .changed:
            let translation = recognizer.translation(in: self.view)
            
            if collectionView.frame.contains(dragStartPos) {
                
            }
            
        default:
            break
        }
    }
}

// MARK: - UICollectionViewDataSource & UICollectionViewDelegate
extension FSLibraryImagePickerController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FSLibraryViewCell", for: indexPath) as! FSLibraryViewCell
        
//        let currentTag = cell.tag + 1
//        cell.tag = currentTag
        
        let asset = images[indexPath.row]
        imageManager.requestImage(for: asset, targetSize: cellSize, contentMode: .aspectFill, options: nil) { (image, info) in
//            if cell.tag == currentTag {
//                cell.image = image
//            }
            cell.image = image
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // TODO
//        let cell = collectionView.cellForItem(at: indexPath) as! FSLibraryViewCell
//        cell.highlightView.isHidden = false
//        
    }
    
}

// MARK: - PHPhotoLibraryChangeObserver
extension FSLibraryImagePickerController: PHPhotoLibraryChangeObserver {
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        // TODO
    }
}

// MARK: - UIGestureRecognizerDelegate
//extension FSLibraryImagePickerController: UIGestureRecognizerDelegate {
//    
//}

protocol FSLibraryImagePickerControllerDelegate {
    func getCropHeightRatio() -> CGFloat
    
    func cameraRollAccessDenied()
    func cameraRollAccessAllowed()
}

