//
//  FSImageEditController.swift
//  FaceSnaps
//
//  Created by Patrick Montalto on 3/11/17.
//  Copyright © 2017 Patrick Montalto. All rights reserved.
//

import Foundation
import UIKit

enum TiltShiftMode {
    case off, radial, linear
}
/// Delegate for FSImageEditView
protocol FSImageEditViewDelegate {
    // Brightness
    func brightnessSliderMove(sender: UISlider)
    // Contrast
    func contrastSliderMove(sender: UISlider)
    // Structure
    func structureSliderMove(sender: UISlider)
    // Warmth
    func warmthSliderMove(sender: UISlider)
    // Saturation
    func saturationSliderMove(sender: UISlider)
    // Highlights
    func highlightsSliderMove(sender: UISlider)
    // Shadows
    func shadowsSliderMove(sender: UISlider)
    // Vignette
    func vignetteSliderMove(sender: UISlider)
    // Tilt Shift
    func tiltShiftChanged(mode: TiltShiftMode)

    func sliderViewDidAppear(type: FSImageSliderType)
    func sliderViewDidDisappear()
}

/// View containing a horizontal collection view and the image editing tools views
class FSImageEditView: UIView {
    var delegate: FSImageEditViewDelegate!
    
    // TODO: Properties for current values of adjustments?
    
    lazy var collectionView: UICollectionView = {
        let cvLayout = UICollectionViewFlowLayout()
        cvLayout.scrollDirection = .horizontal
        cvLayout.minimumInteritemSpacing = 10.0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: cvLayout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = .white
        cv.contentInset = UIEdgeInsets(top: 0.0, left: 12, bottom: 0.0, right: 0.0)
        let nib = UINib(nibName: "FSImageEditViewCell", bundle: nil)
        cv.register(nib, forCellWithReuseIdentifier: "fsImageEditViewCell")
        return cv
    }()
    
    let availableTypes: [FSImageSliderType] = [.brightness, .contrast, .structure]
    
    var activeSliderView: FSImageSliderAdjustmentView? {
        get {
            let unHiddenView = [self.brightnessView, self.contrastView, self.structureView].filter { (imageView) -> Bool in
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
    
    convenience init(delegate: FSImageEditViewDelegate) {
        self.init()
        self.delegate = delegate
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(collectionView)
        addSubview(brightnessView)
        addSubview(contrastView)
        addSubview(structureView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        NSLayoutConstraint.activate([
            // TODO: testing centerYAnchor
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
        ])
    }
    
    func resetSliderValue() {
        guard let activeSliderView = activeSliderView else { return }
        activeSliderView.slider.value = activeSliderView.lastValue
        activeSliderView.sliderMoved(sender: activeSliderView.slider)
    }
    
    func setNewSliderValue() {
        guard let activeSliderView = activeSliderView else { return }
        activeSliderView.lastValue = activeSliderView.slider.value
        activeSliderView.sliderMoved(sender: activeSliderView.slider)
    }
    
    func hideActiveSliderView() {
        guard let activeSliderView = activeSliderView else { return }
        activeSliderView.isHidden = true
    }
}
// MARK: - UICollectionViewDelegate & UICollectionViewDataSource
extension FSImageEditView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return availableTypes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "fsImageEditViewCell", for: indexPath) as! FSImageEditViewCell
        
        configureCell(cell, atIndexPath: indexPath)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // TODO: Handle selection by unhiding the appropriate view
        let type = availableTypes[indexPath.row]
        showView(forSliderType: type)
        delegate.sliderViewDidAppear(type: type)
    }
    
    /// Modifies the cell to the appropriate edit tool type
    private func configureCell(_ cell: FSImageEditViewCell, atIndexPath indexPath: IndexPath) {
        let type = availableTypes[indexPath.row]
        switch type {
        case .brightness:
            cell.label.text = "Brightness"
            cell.iconView.image = UIImage(named: "brightness_icon")!
        case .contrast:
            cell.label.text = "Contrast"
            cell.iconView.image = UIImage(named: "contrast_icon")!
        case .structure:
            cell.label.text = "Structure"
            cell.iconView.image = UIImage(named: "structure_icon")!
        }
    }
    
    /// Unhides and hides the appropriate views
    private func showView(forSliderType type: FSImageSliderType) {
        switch type {
        case .brightness:
            brightnessView.isHidden = false
            contrastView.isHidden = true
            structureView.isHidden = true
        case .contrast:
            brightnessView.isHidden = true
            contrastView.isHidden = false
            structureView.isHidden = true
        case .structure:
            brightnessView.isHidden = true
            contrastView.isHidden = true
            structureView.isHidden = false
        }
    }
    
    // Set cell size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // W: 88 H: 114
        let width = 0.77 * collectionView.frame.height
        return CGSize(width: width, height: collectionView.frame.height)
    }
}
