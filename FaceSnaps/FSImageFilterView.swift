//
//  FSImageFilterController.swift
//  FaceSnaps
//
//  Created by Patrick Montalto on 3/11/17.
//  Copyright © 2017 Patrick Montalto. All rights reserved.
//

import Foundation
import UIKit

protocol FSImageFilterViewDelegate {
    func selectedFilter(filter: FSImageFilter)
    func thumbnailForFilter(filter: FSImageFilter) -> UIImage
//    func imageForFilter(filter: FSImageFilter) -> CIImage
}

/// View containing a horizontal collcetion view and the preset filters.
class FSImageFilterView: UIView {
    var delegate: FSImageFilterViewDelegate!
    
    lazy var filterCollectionView: UICollectionView = {
        let cvLayout = UICollectionViewFlowLayout()
        cvLayout.scrollDirection = .horizontal
        cvLayout.minimumInteritemSpacing = 10.0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: cvLayout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = .white
        cv.showsHorizontalScrollIndicator = false
        cv.contentInset = UIEdgeInsets(top: 0.0, left: 12, bottom: 0.0, right: 12)
//        cv.register(FilteredImageCell.self, forCellWithReuseIdentifier: FilteredImageCell.reuseIdentifier)
        let nib = UINib(nibName: "FSFilterViewCell", bundle: nil)
        cv.register(nib, forCellWithReuseIdentifier: "FSFilterViewCell")
        return cv
    }()
    
    lazy var eaglContext: EAGLContext = {
        return EAGLContext(api: .openGLES2)!
    }()
    lazy var ciContext: CIContext = {
        return CIContext(eaglContext: self.eaglContext)
    }()
    
    convenience init(delegate: FSImageFilterViewDelegate) {
        self.init()
        self.delegate = delegate
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(filterCollectionView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        NSLayoutConstraint.activate([
            filterCollectionView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 8),
            filterCollectionView.leftAnchor.constraint(equalTo: self.leftAnchor),
            filterCollectionView.rightAnchor.constraint(equalTo: self.rightAnchor),
            filterCollectionView.heightAnchor.constraint(equalToConstant: 0.6 * self.frame.height),
        ])
    }
}

// MARK: - UICollectionViewDelegate & UICollectionViewDataSource
extension FSImageFilterView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return FSImageFilter.availableFilters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilteredImageCell.reuseIdentifier, for: indexPath) as! FilteredImageCell
//
//        let filter = FSImageFilter.availableFilters[indexPath.row]
//
//        let thumbnail = delegate.thumbnailForFilter(filter: filter)
//
//        cell.label.text = filter.stringRepresentation
//        cell.ciContext = ciContext
//        cell.eaglContext = eaglContext
//        cell.image = thumbnail
//        
//        return cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FSFilterViewCell", for: indexPath) as! FSFilterViewCell
        let filter = FSImageFilter.availableFilters[indexPath.row]

        cell.filterTitle.text = filter.stringRepresentation
        let thumbnail = delegate.thumbnailForFilter(filter: filter)
        cell.filterThumbnail.image = thumbnail
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let row = indexPath.row
        guard let filter = FSImageFilter(rawValue: row) else {
            print("Unable to get filter from current row")
            return
        }
        // Notify delegate (coordinator) so it can replace the main image view
        delegate.selectedFilter(filter: filter)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // W: 96 H: 114
        let width = 0.84 * collectionView.frame.height
        return CGSize(width: width, height: collectionView.frame.height)
    }
}
