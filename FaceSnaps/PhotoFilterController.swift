//
//  PhotoFilterController.swift
//  FaceSnaps
//
//  Created by Patrick Montalto on 10/2/16.
//  Copyright © 2016 Patrick Montalto. All rights reserved.
//

import UIKit

class PhotoFilterController: UIViewController {
    
    var mainImage: UIImage {
        // Add property observer to update the imageView
        didSet {
            photoImageView.image = mainImage
        }
    }
    let context: CIContext
    let eaglContext: EAGLContext
    
    private let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var filterHeaderLabel: UILabel = {
        let label = UILabel()
        label.text = "Select a filter"
        label.textAlignment = .center
        return label
    }()
    
    lazy var filtersCollectionView: UICollectionView = {
        // Organizes items into a grid with an optional header and footer view for each section:
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 10
        flowLayout.minimumInteritemSpacing = 1000 // Set this high so we have just 1 long row
        flowLayout.itemSize = CGSize(width: 100, height: 100)
        
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = .white
        
        // Register class (since we aren't using storyboard)
        collectionView.register(FilteredImageCell.self, forCellWithReuseIdentifier: FilteredImageCell.reuseIdentifier)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        return collectionView
    }()
    
    lazy var filteredImages: [CIImage] = {
        let filteredImageBuilder = FilteredImageBuilder(context: self.context, image: self.mainImage)
        return filteredImageBuilder.imageWithDefaultFilters()
    }()
    
    init(image: UIImage, context: CIContext, eaglContext: EAGLContext) {
        self.mainImage = image
        self.photoImageView.image = self.mainImage
        self.context = context
        self.eaglContext = eaglContext
        super.init(nibName: nil, bundle: nil)
    }
    
    // Required, using fatalError() because we aren't using Story Boards
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(PhotoFilterController.dismissPhotoFilterController))
        navigationItem.leftBarButtonItem = cancelButton
        
        let nextButton = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(PhotoFilterController.presentMetadataController))
        navigationItem.rightBarButtonItem = nextButton
        
    }
    
    // MARK: - Layout
    
    override func viewWillLayoutSubviews() {
        photoImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(photoImageView)
        
        filterHeaderLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(filterHeaderLabel)
        
        filtersCollectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(filtersCollectionView)
        
        NSLayoutConstraint.activate([
            filtersCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            filtersCollectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            filtersCollectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            filtersCollectionView.heightAnchor.constraint(equalToConstant: 200.0),
            filtersCollectionView.topAnchor.constraint(equalTo: filterHeaderLabel.bottomAnchor),
            filterHeaderLabel.leftAnchor.constraint(equalTo: view.leftAnchor),
            filterHeaderLabel.rightAnchor.constraint(equalTo: view.rightAnchor),
            photoImageView.bottomAnchor.constraint(equalTo: filtersCollectionView.topAnchor),
            photoImageView.topAnchor.constraint(equalTo: view.topAnchor),
            photoImageView.leftAnchor.constraint(equalTo: view.leftAnchor),
            photoImageView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }
}




// MARK: - UICollectionViewDataSource
extension PhotoFilterController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilteredImageCell.reuseIdentifier, for: indexPath) as! FilteredImageCell
        
        let ciImage = filteredImages[indexPath.row]

        cell.ciContext = context
        cell.eaglContext = eaglContext
        cell.image = ciImage
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension PhotoFilterController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let ciImage = filteredImages[indexPath.row]
        
        // If we were to convert to UIImage directly, it wouldn't maintain 
        // propert aspect ratio of the image.
        let cgImage = context.createCGImage(ciImage, from: ciImage.extent)!
        mainImage = UIImage(cgImage: cgImage)
    }
}


// MARK: - Navigation

extension PhotoFilterController {
    func dismissPhotoFilterController() {
        dismiss(animated: true, completion: nil)
    }
    
    func presentMetadataController() {
        let photoMetadataController = PhotoMetadataController(photo: self.mainImage)
        self.navigationController?.pushViewController(photoMetadataController, animated: true)
    }
}


















