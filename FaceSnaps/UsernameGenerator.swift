//
//  UsernameGenerator.swift
//  FaceSnaps
//
//  Created by Patrick Montalto on 1/7/17.
//  Copyright © 2017 Patrick Montalto. All rights reserved.
//

import Foundation

class UsernameGenerator {
    var suggestions = [String]()
    
    init(fullName: String) {
        for _ in 1...10 {
            // Generate 4 digit random number
            let randomNumber = Int(arc4random_uniform(9999) + 1000)
            // Append to full name (underscores for spaces)
            let randomUsername = fullName.replacingOccurrences(of: " ", with: "_") + "\(randomNumber)"
            // Add to array
            suggestions.append(randomUsername)
        }
    }
    
    func suggestUsername() -> String {
        let randomIndex = Int(arc4random_uniform(UInt32(suggestions.count - 1)))
        return suggestions[randomIndex]
    }
}
