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
    
    var currentFilterValues: [FSImageAdjustmentType: FilterValue] = [
        .brightness: FSImageAdjustmentType.brightness.defaultValue,
        .contrast: FSImageAdjustmentType.contrast.defaultValue,
        .structure: FSImageAdjustmentType.structure.defaultValue,
        .warmth: FSImageAdjustmentType.warmth.defaultValue,
    ]
    
    var context: CIContext
    var inputImage: CIImage
    
    init(image: UIImage, context: CIContext) {
        self.inputImage = CIImage(image: image)!
        self.context = context
    }
    
    func editedImage(filter: FSImageAdjustmentType, rawValue: Float) -> CIImage {
//        var ciImage = CIImage()
        switch filter {
        case .brightness:
            return editBrightness(rawValue: rawValue)
        case .contrast:
            return editContrast(rawValue: rawValue)
        case .structure:
            return editStructure(rawValue: rawValue)
        case .warmth:
            return editWarmth(rawValue: rawValue)
        default:
            return CIImage()
        }
    }
    
    private func editBrightness(rawValue: Float) -> CIImage {
        let value = NSNumber(value: (rawValue / 1000.0))
        // Set brightness and image
        brightnessFilter.setValue(value, forKey: kCIInputBrightnessKey)
        brightnessFilter.setValue(inputImage, forKey: kCIInputImageKey)
        
        // Update current stored filter value
        updateStoredValue(value1: value, forType: .brightness)
        
        // Return edited output image
        return brightnessFilter.outputImage!
    }
    
    private func editContrast(rawValue: Float) -> CIImage {
        // Value from 0 to 4
        // Receiving values from -100 to 100
        // rawValue of 0 corresponds to value of 1.
        let value = convertValueToScale(rawValue: rawValue, oldMin: -100.0, oldMax: 100.0, newMin: 0.9, newMax: 1.1)
        contrastFilter.setValue(value, forKey: kCIInputContrastKey)
        contrastFilter.setValue(inputImage, forKey: kCIInputImageKey)
        
        // Update current stored filter value
        updateStoredValue(value1: value, forType: .contrast)
        
        // Return edied output image
        return contrastFilter.outputImage!
    }

    private func editStructure(rawValue: Float) -> CIImage {
        // Edit contrast and sharpness together
        let contrastValue = convertValueToScale(rawValue: rawValue, oldMin: 0, oldMax: 100.0, newMin: 1, newMax: 1.05)
        let sharpnessValue = convertValueToScale(rawValue: rawValue, oldMin: 0, oldMax: 100.0, newMin: 0, newMax: 10)
        
        // Update current stored filter value
        updateStoredValue(value1: contrastValue, value2: sharpnessValue, forType: .structure)
        
        return inputImage.applyingFilter(CIColorControls, withInputParameters: [
                kCIInputContrastKey: contrastValue
            ])
            .applyingFilter(CISharpenLuminance, withInputParameters: [
                kCIInputSharpnessKey: sharpnessValue
            ])
    }
    
    private func editWarmth(rawValue: Float) -> CIImage {
        let invertedValue = -rawValue
        let temperatureValue = convertValueToScale(rawValue: invertedValue, oldMin: -100, oldMax: 100, newMin: 2500, newMax: 10500)
        let inputVector = CIVector(x: CGFloat(temperatureValue), y: 0)
        
        // Update current stored filter value
        updateStoredValue(value1: temperatureValue, forType: .warmth)
        
        warmthFilter.setValue(inputVector, forKey: kCIInputNeutralTemperatureKey)
        warmthFilter.setValue(inputImage, forKey: kCIInputImageKey)
        
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
    
    private func updateStoredValue(value1: NSNumber, value2: NSNumber? = nil, forType type: FSImageAdjustmentType) {
        currentFilterValues[type] = (value1, value2)
    }
    
    private func convertValueToScale(rawValue oldValue: Float, oldMin: Float, oldMax: Float, newMin: Float, newMax: Float) -> NSNumber {
        let newRange = newMax - newMin
        let oldRange = oldMax - oldMin
        let newValue = ((oldValue - oldMin) / oldRange) * newRange + newMin
        return NSNumber(value: newValue)
    }
    
    func resetStoredValue(type: FSImageAdjustmentType) {
        // Cancel button was tapped. The stored value needs to be reset to the last saved value prior to editing.
    }
}
