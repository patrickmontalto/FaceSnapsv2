//
//  FSImageEditToolsController.swift
//  FaceSnaps
//
//  Created by Patrick Montalto on 3/12/17.
//  Copyright © 2017 Patrick Montalto. All rights reserved.
//

import UIKit

/// Contains the filter and edit views for modifying a photo.
class FSImageEditToolsController: UIView {
    // MARK: - Properties
    weak var coordinator: FSImageEditCoordinator?
    var editViewDelegate: FSImageEditViewDelegate!
    var filterViewDelegate: FSImageFilterViewDelegate!
    
    lazy var filterButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16.0, weight: UIFontWeightMedium)
        button.setTitle("Filter", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var editButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.lightGray, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16.0, weight: UIFontWeightMedium)
        button.setTitle("Edit", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var filterSelectionView: FSImageFilterView = {
        let view = FSImageFilterView(delegate: self.filterViewDelegate)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = false
        view.alpha = 1.0
        return view
    }()
    
    lazy var editorSelectionView: FSImageEditView = {
        let view = FSImageEditView(delegate: self.editViewDelegate)
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = 0.0
        return view
    }()
    
    convenience init(coordinator: FSImageEditCoordinator, editViewDelegate: FSImageEditViewDelegate, filterViewDelegate: FSImageFilterViewDelegate) {
        self.init()
        self.coordinator = coordinator
        self.editViewDelegate = editViewDelegate
        self.filterViewDelegate = filterViewDelegate
        
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(filterButton)
        addSubview(editButton)
        addSubview(filterSelectionView)
        addSubview(editorSelectionView)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let filterButtonCenterX = 0.25 * coordinator!.view.frame.width
        let editButtonCenterX = 0.75 * coordinator!.view.frame.width
        
        NSLayoutConstraint.activate([
            filterButton.centerXAnchor.constraint(equalTo: leftAnchor, constant: filterButtonCenterX),
            filterButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            
            
            editButton.centerXAnchor.constraint(equalTo: leftAnchor, constant: editButtonCenterX),
            editButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            
            filterSelectionView.leftAnchor.constraint(equalTo: leftAnchor),
            filterSelectionView.topAnchor.constraint(equalTo: topAnchor),
            filterSelectionView.rightAnchor.constraint(equalTo: rightAnchor),
            filterSelectionView.heightAnchor.constraint(equalToConstant: frame.height - 48),
            
            editorSelectionView.leftAnchor.constraint(equalTo: leftAnchor),
            editorSelectionView.topAnchor.constraint(equalTo: topAnchor),
            editorSelectionView.rightAnchor.constraint(equalTo: rightAnchor),
            editorSelectionView.heightAnchor.constraint(equalToConstant: frame.height - 48),
            
            ])
    }
    
    func filterButtonTapped() {
        filterButton.setTitleColor(.black, for: .normal)
        editButton.setTitleColor(.lightGray, for: .normal)
        // Present FSImageFilterView
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn, animations: { () in
            self.editorSelectionView.alpha = 0.0
            self.filterSelectionView.alpha = 1.0
        }, completion: { (completed) in
            self.editorSelectionView.isHidden = true
            self.filterSelectionView.isHidden = false
        })
        
    }
    
    func editButtonTapped() {
        filterButton.setTitleColor(.lightGray, for: .normal)
        editButton.setTitleColor(.black, for: .normal)
        // Present FSImageEditView
        self.filterSelectionView.isHidden = true
        self.editorSelectionView.isHidden = false
        UIView.animate(withDuration: 0.2) {
            self.editorSelectionView.alpha = 1.0
        }
    }
    
    func resetSlider() {
        // Reset to last value
        editorSelectionView.resetSliderValue()
        // Hide the slider view
        editorSelectionView.toggleActiveIndicator()
        editorSelectionView.hideActiveAdjustmentView()
        editViewDelegate.sliderViewDidDisappear()
    }
    
    func resetTiltShift(mode: TiltShiftMode) {
        let row = mode.rawValue
        let indexPath = IndexPath(row: row, section: 0)
        editorSelectionView.toggleActiveIndicator(mode: mode)
        editorSelectionView.hideActiveAdjustmentView()
        editorSelectionView.tiltShiftCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
        
        editViewDelegate.tiltShiftDidDisappear()
    }
    
    func saveSlider() {
        // Toggle the active indicator
        editorSelectionView.toggleActiveIndicator()
        // Save new value
        editorSelectionView.setNewSliderValue()
        // Hide the slider view
        editorSelectionView.hideActiveAdjustmentView()
        editViewDelegate.sliderViewDidDisappear()
    }
    
    func dismissTiltShift(mode: TiltShiftMode) {
        editorSelectionView.toggleActiveIndicator(mode: mode)
        editorSelectionView.hideActiveAdjustmentView()
        
        editViewDelegate.tiltShiftDidDisappear()
    }
}
