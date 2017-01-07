//
//  Formatter.swift
//  FaceSnaps
//
//  Created by Patrick Montalto on 1/7/17.
//  Copyright © 2017 Patrick Montalto. All rights reserved.
//

import Foundation

struct Formatter {
    private init() {}
    
    static func isValidEmail(_ email: String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
}
