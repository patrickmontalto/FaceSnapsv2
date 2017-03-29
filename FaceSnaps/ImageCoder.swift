//
//  ImageCoder.swift
//  FaceSnaps
//
//  Created by Patrick on 1/10/17.
//  Copyright © 2017 Patrick Montalto. All rights reserved.
//

import Foundation
import UIKit

struct ImageCoder {
    static func encodeToBase64(image: UIImage) -> String? {
        var uiImage = image
        if uiImage.cgImage == nil {
            guard let ciImage = image.ciImage, let cgImage = CIContext(options: nil).createCGImage(ciImage, from: ciImage.extent) else { return nil }
            uiImage = UIImage(cgImage: cgImage)
            
        }
        guard let imageData = UIImageJPEGRepresentation(uiImage, 0.9) else {
            return nil
        }
        
        return imageData.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0))
    }
    
    static func decodeBase64Image(base64: String) -> UIImage? {
        guard let decodedData = Data(base64Encoded: base64, options: Data.Base64DecodingOptions(rawValue: 0)) else {
            return nil
        }
        guard let decodedImage = UIImage(data: decodedData) else { return nil }
        
        return decodedImage
    }
}
