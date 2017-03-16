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
    let CISharpenLuminence = "CISharpenLuminence"
    
    enum EditFilterType {
        case brightness, contrast, structure
    }
    
    lazy var brightnessFilter: CIFilter = {
        return CIFilter(name: self.CIColorControls)!
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
            return CIImage()
        case .structure:
            return CIImage()
        }
        
//        return UIImage(ciImage: ciImage)
    }
    
    private func editBrightness(rawValue: Float) -> CIImage {
        let value = NSNumber(value: (rawValue / 1000.0))
        // Create brightness filter and set the image
//        let filter = CIFilter(name: CIColorControls)!
        brightnessFilter.setValue(value, forKey: kCIInputBrightnessKey)
        brightnessFilter.setValue(inputImage, forKey: kCIInputImageKey)
        
        // Return edited output image
        return brightnessFilter.outputImage!
    }
    
//    private func editContrast(rawValue: Float) -> CIImage {
//        
//    }
//    
//    private func editStructure(rawValue: Float) -> CIImage {
//        
//    }
    
    
}
