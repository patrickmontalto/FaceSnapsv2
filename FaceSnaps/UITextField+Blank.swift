//
//  UITextField+Blank.swift
//  FaceSnaps
//
//  Created by Patrick Montalto on 12/21/16.
//  Copyright © 2016 Patrick Montalto. All rights reserved.
//

import UIKit

extension UITextField {
    
    func isBlank() -> Bool {
        guard let value = self.text, !value.isEmpty else {
            return true
        }
        return false
    }
}
