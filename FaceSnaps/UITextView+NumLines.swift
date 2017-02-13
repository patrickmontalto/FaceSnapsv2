//
//  UITextView+NumLines.swift
//  FaceSnaps
//
//  Created by Patrick Montalto on 2/12/17.
//  Copyright © 2017 Patrick Montalto. All rights reserved.
//

import Foundation
import UIKit

extension UITextView {
    
    func numLines() -> Float {
        let linesFloat = self.contentSize.height / self.font!.lineHeight
        return roundf(Float(linesFloat))
    }
}
