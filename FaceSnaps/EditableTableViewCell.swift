//
//  EditableTableViewCell.swift
//  FaceSnaps
//
//  Created by Patrick Montalto on 2/19/17.
//  Copyright © 2017 Patrick Montalto. All rights reserved.
//

import UIKit

class EditableTableViewCell: UITableViewCell {
    
    @IBOutlet var accessoryImageView: UIImageView!
    
    @IBOutlet var textField: UITextField!

    /// Configures the cell with the appropriate image and text field values
    ///
    /// - parameter accessoryImage: The image for the left accessory view
    /// - parameter placeholder: The placeholder text for the text field
    /// - parameter currentValue: The current text field value or nil
    func configure(accessoryImage: UIImage?, placeholder: String, currentValue: String?) {
        self.accessoryImageView.image = accessoryImage
        self.textField.placeholder = placeholder
        self.textField.text = currentValue
        
        textField.borderStyle = .none
        textField.font = .systemFont(ofSize: 16.0)
    }
}
