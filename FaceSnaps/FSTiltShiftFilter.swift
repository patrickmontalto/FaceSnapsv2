//
//  FSTiltShiftFilter.swift
//  FaceSnaps
//
//  Created by Patrick Montalto on 3/19/17.
//  Copyright © 2017 Patrick Montalto. All rights reserved.
//

import Foundation
import UIKit

struct FSTiltShiftFilter {
    
    let gaussianBlurFilter = CIFilter(name: "CIGaussianBlur")!
    let linearGradientFilter = CIFilter(name: "CILinearGradient")!
    let additionCompositingFilter = CIFilter(name: "CIAdditionCompositing")!
    let blendWithMaskFilter = CIFilter(name: "CIBlendWithMask")!
    
//    func radialShift() -> CIImage {
//        
//    }
    
    func linearShift(inputImage: CIImage) -> CIImage {
        // 1. Create gaussian blurred version of the image
        gaussianBlurFilter.setValue(inputImage, forKey: kCIInputImageKey)
        gaussianBlurFilter.setValue(10.0, forKey: kCIInputRadiusKey)
        var gaussianBlurredImage = gaussianBlurFilter.outputImage!

        let cropRect = CGRect(x: 0, y: 0, width: 2048, height: 2048)
        gaussianBlurredImage = gaussianBlurredImage.cropping(to: cropRect)
        
        // 2. Create two linear gradients
        let h = inputImage.extent.size.height
        
        let inputColor0 = CIColor(red: 0, green: 1, blue: 0, alpha: 1)
        let inputColor1 = CIColor(red: 0, green: 1, blue: 0, alpha: 0)

        let topInputPoint0 = CIVector(x: 0, y: 0.75 * h)
        let topInputPoint1 = CIVector(x: 0, y: 0.5 * h)
        let botInputPoint0 = CIVector(x: 0, y: 0.25 * h)
        let botInputPoint1 = CIVector(x: 0, y: 0.5 * h)
        
        linearGradientFilter.setValue(topInputPoint0, forKey: "inputPoint0")
        linearGradientFilter.setValue(inputColor0, forKey: "inputColor0")
        linearGradientFilter.setValue(topInputPoint1, forKey: "inputPoint1")
        linearGradientFilter.setValue(inputColor1, forKey: "inputColor1")
        let topGradient = linearGradientFilter.outputImage!
        
        linearGradientFilter.setValue(botInputPoint0, forKey: "inputPoint0")
        linearGradientFilter.setValue(inputColor0, forKey: "inputColor0")
        linearGradientFilter.setValue(botInputPoint1, forKey: "inputPoint1")
        linearGradientFilter.setValue(inputColor1, forKey: "inputColor1")
        let bottomGradient = linearGradientFilter.outputImage!
        
        // 3. Create a mask from the linear gradients
        additionCompositingFilter.setValue(topGradient, forKey: kCIInputImageKey)
        additionCompositingFilter.setValue(bottomGradient, forKey: kCIInputBackgroundImageKey)

        let mask = additionCompositingFilter.outputImage!
        
        // 4. Combine the blurred image, source image, and gradients
        blendWithMaskFilter.setValue(gaussianBlurredImage, forKey: kCIInputImageKey)
        blendWithMaskFilter.setValue(inputImage, forKey: kCIInputBackgroundImageKey)
        blendWithMaskFilter.setValue(mask, forKey: kCIInputMaskImageKey)
        
        return blendWithMaskFilter.outputImage!
        
    }
}
