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
    
    var storedFilterValues: [FSImageAdjustmentType: Float] = [
        .brightness: FSImageAdjustmentType.brightness.defaultValue,
        .contrast: FSImageAdjustmentType.contrast.defaultValue,
        .structure: FSImageAdjustmentType.structure.defaultValue,
        .warmth: FSImageAdjustmentType.warmth.defaultValue,
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
        return editedImage(sourceImage, filter: filter, rawValue: rawValue)
    }
    
    func editedImage(_ inputImage: CIImage, filter: FSImageAdjustmentType, rawValue: Float) -> CIImage {
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
        default:
            return CIImage()
        }
        
        currentValue = rawValue
        
        if inputImage == sourceImage {
            for otherFilter in filtersApplied.filter({ $0 != filter }) {
                let value = storedFilterValues[otherFilter]!
                image = editedImageCompounded(image, filter: otherFilter, rawValue: value)
            }
        }
        
        return image
    }
    
    private func editedImageCompounded(_ inputImage: CIImage, filter: FSImageAdjustmentType, rawValue: Float) -> CIImage {
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
        default:
            return CIImage()
        }
        
        return image
    }
    
    private func editBrightness(image: CIImage, rawValue: Float) -> CIImage {
        let value = NSNumber(value: (rawValue / 1000.0))
        // Set brightness and image
        brightnessFilter.setValue(value, forKey: kCIInputBrightnessKey)
        brightnessFilter.setValue(image, forKey: kCIInputImageKey)
        
        // Update current filter value
//        updateCurrentValue(rawValue)
        
        // Return edited output image
        return brightnessFilter.outputImage!
    }
    
    private func editContrast(image: CIImage, rawValue: Float) -> CIImage {
        // Value from 0 to 4
        // Receiving values from -100 to 100
        // rawValue of 0 corresponds to value of 1.
        let value = convertValueToScale(rawValue: rawValue, oldMin: -100.0, oldMax: 100.0, newMin: 0.9, newMax: 1.1)
        contrastFilter.setValue(value, forKey: kCIInputContrastKey)
        contrastFilter.setValue(image, forKey: kCIInputImageKey)
        // Update current filter value
//        updateCurrentValue(value1: value)
        
        // Return edied output image
        return contrastFilter.outputImage!
    }

    private func editStructure(image: CIImage, rawValue: Float) -> CIImage {
        // Edit contrast and sharpness together
        let contrastValue = convertValueToScale(rawValue: rawValue, oldMin: 0, oldMax: 100.0, newMin: 1, newMax: 1.05)
        let sharpnessValue = convertValueToScale(rawValue: rawValue, oldMin: 0, oldMax: 100.0, newMin: 0, newMax: 10)
        
        // Update current stored filter value
//        updateCurrentValue(value1: contrastValue, value2: sharpnessValue)
        
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
        
        // Update current filter value
//        updateCurrentValue(value1: temperatureValue)
        
        warmthFilter.setValue(inputVector, forKey: "inputNeutral")
        warmthFilter.setValue(image, forKey: kCIInputImageKey)
        
        return warmthFilter.outputImage!
    }
//    private func editSaturation(rawValue: Float) -> CIImage {
//        
//    }
//    private func editHighlights(rawValue: Float) -> CIImage {
//        
//    }
//    private func editShadows(rawValue: Float) -> CIImage {
//        
//    }
//    private func editVignette(rawValue: Float) -> CIImage {
//        
//    }
//    
//    private func toggleTiltShift(mode: TiltShiftMode) -> CIImage {
//        
//    }
    
//    private func updateCurrentValue(value1: NSNumber, value2: NSNumber? = nil) {
//        currentValue = (value1, value2)
//    }
    
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
