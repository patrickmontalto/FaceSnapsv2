//
//  FSImageEditFilterManager.swift
//  FaceSnaps
//
//  Created by Patrick on 3/15/17.
//  Copyright © 2017 Patrick Montalto. All rights reserved.
//

import Foundation
import UIKit


class FSImageEditFilterManager {
    
    // TODO: Move into a separate enum/struct to be shared for Filter and Edit tools
    let CIColorControls = "CIColorControls"
    let CISharpenLuminance = "CISharpenLuminance"
    let CITemperatureAndTint = "CITemperatureAndTint"
    let CIHighlightShadowAdjust = "CIHighlightShadowAdjust"
    let CIVignette = "CIVignette"
    
    lazy var brightnessFilter: CIFilter = {
        return CIFilter(name: self.CIColorControls)!
    }()
    
    lazy var contrastFilter: CIFilter = {
        return CIFilter(name: self.CIColorControls)!
    }()
    
    lazy var sharpenLuminanceFilter: CIFilter = {
        return CIFilter(name: self.CISharpenLuminance)!
    }()
    
    lazy var warmthFilter: CIFilter = {
        return CIFilter(name: self.CITemperatureAndTint)!
    }()

    lazy var saturationFilter: CIFilter = {
        return CIFilter(name: self.CIColorControls)!
    }()
    
    lazy var highlightsFilter: CIFilter = {
        return CIFilter(name: self.CIHighlightShadowAdjust)!
    }()
    
    lazy var shadowsFilter: CIFilter = {
        return CIFilter(name: self.CIHighlightShadowAdjust)!
    }()

    lazy var vignetteFilter: CIFilter = {
        return CIFilter(name: self.CIVignette)!
    }()
    
    var tiltShiftFilter = FSTiltShiftFilter()
    
    var storedFilterValues: [FSImageAdjustmentType: Float] = [
        .brightness: FSImageAdjustmentType.brightness.defaultValue,
        .contrast: FSImageAdjustmentType.contrast.defaultValue,
        .structure: FSImageAdjustmentType.structure.defaultValue,
        .warmth: FSImageAdjustmentType.warmth.defaultValue,
        .saturation: FSImageAdjustmentType.saturation.defaultValue,
        .highlights: FSImageAdjustmentType.highlights.defaultValue,
        .shadows: FSImageAdjustmentType.shadows.defaultValue,
        .vignette: FSImageAdjustmentType.vignette.defaultValue,
        .tiltshift: FSImageAdjustmentType.tiltshift.defaultValue
    ]
    
    var currentValue: Float?
    
    var filtersApplied: [FSImageAdjustmentType] {
        get {
            return storedFilterValues.filter() { (key, value) in
                return !(key.defaultValue == value)
            }
            .map() { (key, value) in
                return key
            }
        }
    }
    
    var context: CIContext
    var sourceImage: CIImage
    
    init(image: UIImage, context: CIContext) {
        self.sourceImage = CIImage(image: image)!
        self.context = context
    }
    
    func editedInputImage(filter: FSImageAdjustmentType, rawValue: Float) -> CIImage {
        return editedImage(sourceImage, filter: filter, rawValue: rawValue, sourceImage: true)
    }
    
    func editedImage(_ inputImage: CIImage, filter: FSImageAdjustmentType, rawValue: Float, sourceImage: Bool) -> CIImage {
        var image = CIImage()
        switch filter {
        case .brightness:
            image = editBrightness(image: inputImage, rawValue: rawValue)
        case .contrast:
            image = editContrast(image: inputImage, rawValue: rawValue)
        case .structure:
            image = editStructure(image: inputImage, rawValue: rawValue)
        case .warmth:
            image = editWarmth(image: inputImage, rawValue: rawValue)
        case .saturation:
            image = editSaturation(image: inputImage, rawValue: rawValue)
        case .highlights:
            image = editHighlights(image: inputImage, rawValue: rawValue)
        case .shadows:
            image = editShadows(image: inputImage, rawValue: rawValue)
        case .vignette:
            image = editVignette(image: inputImage, rawValue: rawValue)
        case .tiltshift:
            let mode = TiltShiftMode(rawValue: Int(rawValue))!
            image = toggleTiltShift(image: inputImage, mode: mode)
        }
        // If this is the source image, remaining filters will need to be applied
        if sourceImage {
            currentValue = rawValue
            for otherFilter in filtersApplied.filter({ $0 != filter }) {
                let value = storedFilterValues[otherFilter]!
                image = editedImage(image, filter: otherFilter, rawValue: value, sourceImage: false)
            }
        }
        return image
    }
    
    private func editBrightness(image: CIImage, rawValue: Float) -> CIImage {
        let value = NSNumber(value: (rawValue / 1000.0))
        // Set brightness and image
        brightnessFilter.setValue(value, forKey: kCIInputBrightnessKey)
        brightnessFilter.setValue(image, forKey: kCIInputImageKey)
        
        // Return edited output image
        return brightnessFilter.outputImage!
    }
    
    private func editContrast(image: CIImage, rawValue: Float) -> CIImage {
        let value = convertValueToScale(rawValue: rawValue, oldMin: -100.0, oldMax: 100.0, newMin: 0.9, newMax: 1.1)
        contrastFilter.setValue(value, forKey: kCIInputContrastKey)
        contrastFilter.setValue(image, forKey: kCIInputImageKey)
        
        // Return edied output image
        return contrastFilter.outputImage!
    }

    private func editStructure(image: CIImage, rawValue: Float) -> CIImage {
        // Edit contrast and sharpness together
        let contrastValue = convertValueToScale(rawValue: rawValue, oldMin: 0, oldMax: 100.0, newMin: 1, newMax: 1.05)
        let sharpnessValue = convertValueToScale(rawValue: rawValue, oldMin: 0, oldMax: 100.0, newMin: 0, newMax: 10)
        
        return image.applyingFilter(CIColorControls, withInputParameters: [
                kCIInputContrastKey: contrastValue
            ])
            .applyingFilter(CISharpenLuminance, withInputParameters: [
                kCIInputSharpnessKey: sharpnessValue
            ])
    }
    
    private func editWarmth(image: CIImage, rawValue: Float) -> CIImage {
        let temperatureValue = convertValueToScale(rawValue: rawValue, oldMin: -100, oldMax: 100, newMin: 2000, newMax: 11000)
        let inputVector = CIVector(x: CGFloat(temperatureValue), y: 0)
        
        warmthFilter.setValue(inputVector, forKey: "inputNeutral")
        warmthFilter.setValue(image, forKey: kCIInputImageKey)
        
        return warmthFilter.outputImage!
    }
    private func editSaturation(image: CIImage, rawValue: Float) -> CIImage {
        let value = convertValueToScale(rawValue: rawValue, oldMin: -100.0, oldMax: 100.0, newMin: 0, newMax: 2)
        saturationFilter.setValue(value, forKey: kCIInputSaturationKey)
        saturationFilter.setValue(image, forKey: kCIInputImageKey)
        
        // Return edied output image
        return saturationFilter.outputImage!
    }
    private func editHighlights(image: CIImage, rawValue: Float) -> CIImage {
        let value = convertValueToScale(rawValue: rawValue, oldMin: -100.0, oldMax: 100.0, newMin: -5, newMax: 7)
        highlightsFilter.setValue(value, forKey: "inputHighlightAmount")
        highlightsFilter.setValue(image, forKey: kCIInputImageKey)
        
        return highlightsFilter.outputImage!
    }
    private func editShadows(image: CIImage, rawValue: Float) -> CIImage {
        let value = convertValueToScale(rawValue: rawValue, oldMin: -100.0, oldMax: 100.0, newMin: -5, newMax: 5)
        shadowsFilter.setValue(value, forKey: "inputShadowAmount")
        shadowsFilter.setValue(image, forKey: kCIInputImageKey)
        
        return shadowsFilter.outputImage!
    }
    private func editVignette(image: CIImage, rawValue: Float) -> CIImage {
        let value = convertValueToScale(rawValue: rawValue, oldMin: -100.0, oldMax: 100.0, newMin: 0, newMax: 5)
        vignetteFilter.setValue(value, forKey: kCIInputIntensityKey)
        vignetteFilter.setValue(image, forKey: kCIInputImageKey)
        
        return vignetteFilter.outputImage!
    }
    
    private func toggleTiltShift(image: CIImage, mode: TiltShiftMode) -> CIImage {
        switch mode {
        case .off:
            return image
        case .linear:
            return tiltShiftFilter.linearShift(inputImage: image)
        case .radial:
            return tiltShiftFilter.radialShift(inputImage: image)
        }
    }
    
    func resetTiltShiftImage() -> CIImage? {
        let oldTiltShiftValue = storedFilterValues[.tiltshift]!
        return editedInputImage(filter: .tiltshift, rawValue: oldTiltShiftValue)
    }
    
    func updateStoredValue(forType type: FSImageAdjustmentType) {
        // Done button tapped. Update the stored value.
        storedFilterValues[type] = currentValue!
    }
    
    private func convertValueToScale(rawValue oldValue: Float, oldMin: Float, oldMax: Float, newMin: Float, newMax: Float) -> NSNumber {
        let newRange = newMax - newMin
        let oldRange = oldMax - oldMin
        let newValue = ((oldValue - oldMin) / oldRange) * newRange + newMin
        return NSNumber(value: newValue)
    }
}
