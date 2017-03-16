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
    
    enum EditFilterType {
        case brightness, contrast, structure
    }
    
    lazy var brightnessFilter: CIFilter = {
        return CIFilter(name: self.CIColorControls)!
    }()
    
    lazy var contrastFilter: CIFilter = {
        return CIFilter(name: self.CIColorControls)!
    }()
    
    lazy var sharpenLuminanceFilter: CIFilter = {
        return CIFilter(name: self.CISharpenLuminance)!
    }()
    
    var context: CIContext
    var inputImage: CIImage
    
    init(image: UIImage, context: CIContext) {
        self.inputImage = CIImage(image: image)!
        self.context = context
    }
    
    func editedImage(filter: EditFilterType, rawValue: Float) -> CIImage {
//        var ciImage = CIImage()
        switch filter {
        case .brightness:
            return editBrightness(rawValue: rawValue)
        case .contrast:
            return editContrast(rawValue: rawValue)
        case .structure:
            return editStructure(rawValue: rawValue)
        }
    }
    
    private func editBrightness(rawValue: Float) -> CIImage {
        let value = NSNumber(value: (rawValue / 1000.0))
        // Set brightness and image
        brightnessFilter.setValue(value, forKey: kCIInputBrightnessKey)
        brightnessFilter.setValue(inputImage, forKey: kCIInputImageKey)
        
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
        
        // Return edied output image
        return contrastFilter.outputImage!
    }

    private func editStructure(rawValue: Float) -> CIImage {
        // Edit contrast and sharpness together
        let contrastValue = convertValueToScale(rawValue: rawValue, oldMin: 0, oldMax: 100.0, newMin: 1, newMax: 1.05)
        let sharpnessValue = convertValueToScale(rawValue: rawValue, oldMin: 0, oldMax: 100.0, newMin: 0, newMax: 10)
        
//        return inputImage.applyingFilter(CIColorControls, withInputParameters: [
//                kCIInputContrastKey: contrastValue
//            ])
//            .applyingFilter(CISharpenLuminance, withInputParameters: [
//                kCIInputSharpnessKey: sharpnessValue
//            ])
//        contrastFilter.setValue(contrastValue, forKey: kCIInputContrastKey)
//        contrastFilter.setValue(inputImage, forKey: kCIInputImageKey)
//        let contrastedImage = contrastFilter.outputImage!
//        
//        return contrastedImage
        sharpenLuminanceFilter.setValue(sharpnessValue, forKey: kCIInputSharpnessKey)
        sharpenLuminanceFilter.setValue(inputImage, forKey: kCIInputImageKey)
        
        return sharpenLuminanceFilter.outputImage!
    }
    
    private func convertValueToScale(rawValue oldValue: Float, oldMin: Float, oldMax: Float, newMin: Float, newMax: Float) -> NSNumber {
        let newRange = newMax - newMin
        let oldRange = oldMax - oldMin
        let newValue = ((oldValue - oldMin) / oldRange) * newRange + newMin
        return NSNumber(value: newValue)
    }
}
