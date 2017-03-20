//
//  FSImageEditController.swift
//  FaceSnaps
//
//  Created by Patrick Montalto on 3/11/17.
//  Copyright © 2017 Patrick Montalto. All rights reserved.
//

import Foundation
import UIKit

enum TiltShiftMode: Int {
    case off = 0, radial, linear
    
    var stringRepresentation: String {
        switch self {
        case .off:
            return "Off"
        case .radial:
            return "Radial"
        case .linear:
            return "Linear"
        }
    }
    
    var offIcon: UIImage {
        switch self {
        case .off:
            return UIImage(named:"tiltshift_off")!
        case .radial:
            return UIImage(named:"tiltshift_radial")!
        case .linear:
            return UIImage(named:"tiltshift_linear")!
        }
    }
    
    var onIcon: UIImage {
        switch self {
        case .off:
            return UIImage(named:"tiltshift_off_on")!
        case .radial:
            return UIImage(named:"tiltshift_radial_on")!
        case .linear:
            return UIImage(named:"tiltshift_linear_on")!
        }
    }
}
/// Delegate for FSImageEditView
protocol FSImageEditViewDelegate {
    // Slider effect changes
    func sliderMoved(type: FSImageAdjustmentType, sender: UISlider)

    func sliderViewDidAppear(type: FSImageAdjustmentType)
    func sliderViewDidDisappear()
    
    // Tilt shift effect changes
    func tiltShiftChanged(mode: TiltShiftMode)
    
    func tiltShiftDidAppear()
    func tiltShiftDidDisappear()

}

/// View containing a horizontal collection view and the image editing tools views
class FSImageEditView: UIView {
    var delegate: FSImageEditViewDelegate!
    
    lazy var collectionView: UICollectionView = {
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
        let nib = UINib(nibName: "FSImageEditViewCell", bundle: nil)
        cv.register(nib, forCellWithReuseIdentifier: "fsImageEditViewCell")
        return cv
    }()
    
    lazy var tiltShiftCollectionView: UICollectionView = {
        let cvLayout = UICollectionViewFlowLayout()
        cvLayout.scrollDirection = .horizontal
        cvLayout.minimumInteritemSpacing = 10.0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: cvLayout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = .white
        cv.showsHorizontalScrollIndicator = false
        // TODO: Center all 3 cells
        let nib = UINib(nibName: "FSImageEditViewCell", bundle: nil)
        cv.register(nib, forCellWithReuseIdentifier: "fsImageEditViewCell")
        cv.isHidden = true
        cv.tag = FSImageAdjustmentType.tiltshift.rawValue
        return cv
    }()
    
    let availableTypes: [FSImageAdjustmentType] = [.brightness, .contrast, .structure, .warmth, .saturation, .highlights, .shadows, .vignette, .tiltshift]
    
    var filterStatuses = [FSImageAdjustmentType : Bool]()
    
    let tiltShiftModes: [TiltShiftMode] = [.off, .radial, .linear]
    
    var activeAdjustmentView: UIView? {
        get {
            let unHiddenView = [
                self.brightnessView, self.contrastView, self.structureView,
                self.warmthView, self.saturationView, self.highlightsView,
                self.shadowsView, self.vignetteView, self.tiltShiftCollectionView
            ].filter { (imageView) -> Bool in
                return imageView.isHidden == false
            }
            return unHiddenView.first
        }
    }
    
    lazy var brightnessView: FSImageSliderAdjustmentView = {
        return FSImageSliderAdjustmentView(delegate: self.delegate, type: .brightness)
    }()
    
    lazy var contrastView: FSImageSliderAdjustmentView = {
        return FSImageSliderAdjustmentView(delegate: self.delegate, type: .contrast)
    }()
    
    lazy var structureView: FSImageSliderAdjustmentView = {
        return FSImageSliderAdjustmentView(delegate: self.delegate, type: .structure)
    }()
    
    lazy var warmthView: FSImageSliderAdjustmentView = {
        return FSImageSliderAdjustmentView(delegate: self.delegate, type: .warmth)
    }()
    
    lazy var saturationView: FSImageSliderAdjustmentView = {
        return FSImageSliderAdjustmentView(delegate: self.delegate, type: .saturation)
    }()
    
    lazy var highlightsView: FSImageSliderAdjustmentView = {
        return FSImageSliderAdjustmentView(delegate: self.delegate, type: .highlights)
    }()
    
    lazy var shadowsView: FSImageSliderAdjustmentView = {
        return FSImageSliderAdjustmentView(delegate: self.delegate, type: .shadows)
    }()
    
    lazy var vignetteView: FSImageSliderAdjustmentView = {
        return FSImageSliderAdjustmentView(delegate: self.delegate, type: .vignette)
    }()
    
    convenience init(delegate: FSImageEditViewDelegate) {
        self.init()
        self.delegate = delegate
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(collectionView)
        addSubview(brightnessView)
        addSubview(contrastView)
        addSubview(structureView)
        addSubview(warmthView)
        addSubview(saturationView)
        addSubview(highlightsView)
        addSubview(shadowsView)
        addSubview(vignetteView)
        addSubview(tiltShiftCollectionView)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        NSLayoutConstraint.activate([
            collectionView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 8),
            collectionView.leftAnchor.constraint(equalTo: self.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: self.rightAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 0.6 * self.frame.height),
            
            brightnessView.topAnchor.constraint(equalTo: self.topAnchor),
            brightnessView.leftAnchor.constraint(equalTo: self.leftAnchor),
            brightnessView.rightAnchor.constraint(equalTo: self.rightAnchor),
            brightnessView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            contrastView.topAnchor.constraint(equalTo: self.topAnchor),
            contrastView.leftAnchor.constraint(equalTo: self.leftAnchor),
            contrastView.rightAnchor.constraint(equalTo: self.rightAnchor),
            contrastView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            structureView.topAnchor.constraint(equalTo: self.topAnchor),
            structureView.leftAnchor.constraint(equalTo: self.leftAnchor),
            structureView.rightAnchor.constraint(equalTo: self.rightAnchor),
            structureView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            warmthView.topAnchor.constraint(equalTo: self.topAnchor),
            warmthView.leftAnchor.constraint(equalTo: self.leftAnchor),
            warmthView.rightAnchor.constraint(equalTo: self.rightAnchor),
            warmthView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            saturationView.topAnchor.constraint(equalTo: self.topAnchor),
            saturationView.leftAnchor.constraint(equalTo: self.leftAnchor),
            saturationView.rightAnchor.constraint(equalTo: self.rightAnchor),
            saturationView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            highlightsView.topAnchor.constraint(equalTo: self.topAnchor),
            highlightsView.leftAnchor.constraint(equalTo: self.leftAnchor),
            highlightsView.rightAnchor.constraint(equalTo: self.rightAnchor),
            highlightsView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            shadowsView.topAnchor.constraint(equalTo: self.topAnchor),
            shadowsView.leftAnchor.constraint(equalTo: self.leftAnchor),
            shadowsView.rightAnchor.constraint(equalTo: self.rightAnchor),
            shadowsView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            vignetteView.topAnchor.constraint(equalTo: self.topAnchor),
            vignetteView.leftAnchor.constraint(equalTo: self.leftAnchor),
            vignetteView.rightAnchor.constraint(equalTo: self.rightAnchor),
            vignetteView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            tiltShiftCollectionView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 8),
            tiltShiftCollectionView.leftAnchor.constraint(equalTo: self.leftAnchor),
            tiltShiftCollectionView.rightAnchor.constraint(equalTo: self.rightAnchor),
            tiltShiftCollectionView.heightAnchor.constraint(equalToConstant: 0.6 * self.frame.height),
        ])
        
        centerTiltShiftView()
    }
    
    func resetSliderValue() {
        guard let activeSliderView = activeAdjustmentView as? FSImageSliderAdjustmentView else { return }
        activeSliderView.slider.value = activeSliderView.lastValue
        activeSliderView.sliderMoved(sender: activeSliderView.slider)
    }

    /// Stores the current slider value as the lastValue of the activeSliderView.
    /// Also reloads the collectionViewCell 
    func setNewSliderValue() {
        guard let activeSliderView = activeAdjustmentView as? FSImageSliderAdjustmentView else { return }
        activeSliderView.lastValue = activeSliderView.slider.value
        activeSliderView.sliderMoved(sender: activeSliderView.slider)
        
        let type = activeSliderView.type!
        let row = type.rawValue
        let indexPath = IndexPath(row: row, section: 0)
        collectionView.reloadItems(at: [indexPath])
    }
    
    /// Hides the active adjustment view
    func hideActiveAdjustmentView() {
        activeAdjustmentView?.isHidden = true
    }
    
    /// Hides/displays the active indicator for a given edit adjustment cell
    func toggleActiveIndicator(mode: TiltShiftMode? = nil) {
        if let activeAdjustmentView = self.activeAdjustmentView as? FSImageSliderAdjustmentView {
            let active = roundf(activeAdjustmentView.slider.value) != 0
            let type = FSImageAdjustmentType(rawValue: activeAdjustmentView.tag)!
            activeAdjustmentView.isHidden = true
            // When hiding active slider view, determine whether or not it is an active filter (value != default)
            filterStatuses[type] = active
        } else if let activeAdjustmentView = self.activeAdjustmentView as? UICollectionView {
            let active = mode!.rawValue == 0
            let type = FSImageAdjustmentType.tiltshift
            activeAdjustmentView.isHidden = true
            // When hiding active slider view, determine whether or not it is an active filter (value != default)
            filterStatuses[type] = active
        }
    }
    
    /// Call this function for when the view loads
    func selectDefaultForTiltShift() {
        tiltShiftCollectionView.selectItem(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: [])
    }
    
}
// MARK: - UICollectionViewDelegate & UICollectionViewDataSource
extension FSImageEditView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.collectionView {
            return availableTypes.count
        } else {
            return tiltShiftModes.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "fsImageEditViewCell", for: indexPath) as! FSImageEditViewCell
        configureCell(cell, atIndexPath: indexPath, forCollectionView: collectionView)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.collectionView {
            let type = availableTypes[indexPath.row]
            showView(forAdjustmentType: type)
            delegate.sliderViewDidAppear(type: type)
        } else {
            let mode = tiltShiftModes[indexPath.row]
//            let cell = self.collectionView(collectionView, cellForItemAt: indexPath) as! FSImageEditViewCell
//            cell.iconView.image = mode.onIcon
//            let unselectedModes = tiltShiftModes.filter() { $0 != mode }
            delegate.tiltShiftChanged(mode: mode)
        }
        // TODO: Configure for selecting tilt shift effects (off, radial, linear)
    }
    
    /// Modifies the cell to the appropriate edit tool type
    private func configureCell(_ cell: FSImageEditViewCell, atIndexPath indexPath: IndexPath, forCollectionView collectionView: UICollectionView) {
        if collectionView == self.collectionView {
            let type = availableTypes[indexPath.row]
            
            cell.label.text = type.stringRepresentation
            cell.iconView.image = type.icon

//            if let activeSliderView = activeAdjustmentView as? FSImageSliderAdjustmentView {
//                // Get the current type and the current type's associated collection view cell
//                // Display the active indicator if the slider value is not the default value
//                let hide = roundf(activeSliderView.slider.value) == type.defaultValue
//                cell.hideActiveIndicator(hide)
//            } else if let activeAdjustmentView = activeAdjustmentView as? UICollectionView {
//            }
            if filterStatuses[type] == true {
                cell.hideActiveIndicator(false)
            } else {
                cell.hideActiveIndicator(true)
            }
        } else {
            let mode = tiltShiftModes[indexPath.row]
            
            cell.label.text = mode.stringRepresentation
            cell.iconView.image = mode.offIcon
            cell.hideActiveIndicator(true)
            cell.mode = mode
        }
    }

    
    /// Unhides and hides the appropriate views
    private func showView(forAdjustmentType type: FSImageAdjustmentType) {
        // Get a collection of the adjustment views and tilt shift view
        let adjustmentViews = subviews.filter() { $0 is FSImageSliderAdjustmentView || $0 == tiltShiftCollectionView }
        for view in adjustmentViews {
            if view.tag == type.rawValue {
                view.isHidden = false
            } else {
                view.isHidden = true
            }
        }
    }
    
    // Set cell size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // W: 88 H: 114
        let width = 0.77 * collectionView.frame.height
        return CGSize(width: width, height: collectionView.frame.height)
    }
    
    // Center the tilt shift collectionView insets [--[O]-[O]-[O]--]
    func centerTiltShiftView() {
        let width = collectionView(tiltShiftCollectionView, layout: UICollectionViewLayout(), sizeForItemAt: IndexPath(row: 0, section:0)).width
        let distance: CGFloat = 10
        let sideMargin = (UIScreen.main.bounds.width - ((3 * width) + (2 * distance))) / 2
        tiltShiftCollectionView.contentInset = UIEdgeInsetsMake(0, sideMargin, 0, sideMargin)
    }
}
