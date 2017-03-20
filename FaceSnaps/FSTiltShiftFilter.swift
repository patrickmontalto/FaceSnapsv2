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
    let radialGradientFilter = CIFilter(name: "CIRadialGradient")!
    
    func radialShift(inputImage: CIImage) -> CIImage {
        // 1. Create gaussian blurred version of the image
        let gaussianBlurredImage = self.gaussianBlurredImage(inputImage: inputImage)
        
        // 2. Create radial gradient mask
        let inputColor0 = CIColor(red: 0, green: 1, blue: 0, alpha: 1)
        let inputColor1 = CIColor(red: 0, green: 1, blue: 0, alpha: 0)
        
        let mask = radialGradientMask(inputImage: inputImage, inputColor0: inputColor0, inputColor1: inputColor1, inputPercentage: 0.5)
        
        // 3. Combine the blurred image, source image, and gradients
        let tiltShiftedImage = applyTiltShift(inputImage: gaussianBlurredImage, gaussianBlurredImage: inputImage, mask: mask)
        
        return tiltShiftedImage
    }
    
    func linearShift(inputImage: CIImage) -> CIImage {
        // 1. Create gaussian blurred version of the image
        let gaussianBlurredImage = self.gaussianBlurredImage(inputImage: inputImage)
        
        // 2. Create two linear gradients to and their composited mask
        let inputColor0 = CIColor(red: 0, green: 1, blue: 0, alpha: 1)
        let inputColor1 = CIColor(red: 0, green: 1, blue: 0, alpha: 0)

        let mask = linearGradientMask(inputImage: inputImage, inputColor0: inputColor0, inputColor1: inputColor1, vectors: nil)

        // 3. Combine the blurred image, source image, and gradients
        let tiltShiftedImage = applyTiltShift(inputImage: inputImage, gaussianBlurredImage: gaussianBlurredImage, mask: mask)
        
        return tiltShiftedImage
    }
    
    /// Returns an image temporarily used during the animation of applying a tilt shift filter
    func tiltShiftAnimation(inputImage: CIImage, mode: TiltShiftMode) -> CIImage? {
        let whiteImage = UIImage.with(color: .white, bounds: CGRect(x: 0, y: 0, width: inputImage.extent.width / 2, height: inputImage.extent.height / 2))
        let whiteCIImage = CIImage(image: whiteImage!)!
        let h = inputImage.extent.height
        
        // Use white for gradients
        let inputColor0 = CIColor(red: 1, green: 1, blue: 1, alpha: 1)
        let inputColor1 = CIColor(red: 1, green: 1, blue: 1, alpha: 0)
        
        if mode == .linear {
            let v1 = CIVector(x: 0, y: 0.75 * h)
            let v2 = CIVector(x: 0, y: 0.7 * h)
            let v3 = CIVector(x: 0, y: 0.25 * h)
            let v4 = CIVector(x: 0, y: 0.3 * h)
            let gradient = linearGradientMask(inputImage: inputImage, inputColor0: inputColor0, inputColor1: inputColor1, vectors: [v1,v2,v3,v4])
            
            return applyTiltShift(inputImage: inputImage, gaussianBlurredImage: whiteCIImage
                , mask: gradient)
        } else if mode == .radial{
            let mask = radialGradientMask(inputImage: inputImage, inputColor0: inputColor0, inputColor1: inputColor1, inputPercentage: 0.5)
            return applyTiltShift(inputImage: whiteCIImage, gaussianBlurredImage: inputImage, mask: mask)
        } else {
            return nil
        }
    }
    
    /// Returns a gaussian blurred version of the CIImage
    func gaussianBlurredImage(inputImage: CIImage) -> CIImage {
        let height = inputImage.extent.height
        let width = inputImage.extent.width
        gaussianBlurFilter.setValue(inputImage, forKey: kCIInputImageKey)
        gaussianBlurFilter.setValue(10.0, forKey: kCIInputRadiusKey)
        let gaussianBlurredImage = gaussianBlurFilter.outputImage!
        
        let cropRect = CGRect(x: 0, y: 0, width: width, height: height)
        return gaussianBlurredImage.cropping(to: cropRect)
    }
    
    /// Returns a radial gradient mask CIImage
    func radialGradientMask(inputImage: CIImage, inputColor0: CIColor, inputColor1: CIColor, inputPercentage: NSNumber = 1.0) -> CIImage {
        let centerX = inputImage.extent.width / 2
        let centerY = inputImage.extent.height / 2
        let inputCenter = CIVector(x: centerX, y: centerY)
        
        let smallerDimension = min(inputImage.extent.width, inputImage.extent.height)
        let largerDimension = max(inputImage.extent.width, inputImage.extent.height)
        
        let inputRadius0 = smallerDimension / 2.0 * CGFloat(inputPercentage)
        let inputRadius1 = largerDimension / 2.0
        
        radialGradientFilter.setValue(inputCenter, forKey: kCIInputCenterKey)
        radialGradientFilter.setValue(inputRadius0, forKey: "inputRadius0")
        radialGradientFilter.setValue(inputRadius1, forKey: "inputRadius1")
        radialGradientFilter.setValue(inputColor0, forKey: "inputColor0")
        radialGradientFilter.setValue(inputColor1, forKey: "inputColor1")
        
        return radialGradientFilter.outputImage!
    }
    
    /// Returns a top and bottom linear gradient mask CIImage
    func linearGradientMask(inputImage: CIImage, inputColor0: CIColor, inputColor1: CIColor, vectors: [CIVector]?) -> CIImage {
        
        let h = inputImage.extent.size.height
        
        var topInputPoint0: CIVector
        var topInputPoint1: CIVector
        var botInputPoint0: CIVector
        var botInputPoint1: CIVector
        
        if let vectors = vectors {
            topInputPoint0 = vectors[0]
            topInputPoint1 = vectors[1]
            botInputPoint0 = vectors[2]
            botInputPoint1 = vectors[3]
        } else {
            topInputPoint0 = CIVector(x: 0, y: 0.75 * h)
            topInputPoint1 = CIVector(x: 0, y: 0.5 * h)
            botInputPoint0 = CIVector(x: 0, y: 0.25 * h)
            botInputPoint1 = CIVector(x: 0, y: 0.5 * h)
        }
        
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
        
        additionCompositingFilter.setValue(topGradient, forKey: kCIInputImageKey)
        additionCompositingFilter.setValue(bottomGradient, forKey: kCIInputBackgroundImageKey)
        
        let mask = additionCompositingFilter.outputImage!
        
        return mask
    }
    
    /// Returns the tilt-shifted image by combining a mask with a gaussian blurred image and the source image
    func applyTiltShift(inputImage: CIImage, gaussianBlurredImage: CIImage, mask: CIImage) -> CIImage {
        blendWithMaskFilter.setValue(gaussianBlurredImage, forKey: kCIInputImageKey)
        blendWithMaskFilter.setValue(inputImage, forKey: kCIInputBackgroundImageKey)
        blendWithMaskFilter.setValue(mask, forKey: kCIInputMaskImageKey)

        return blendWithMaskFilter.outputImage!
    }
}
