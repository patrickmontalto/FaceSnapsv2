//
//  TimeView.swift
//  FaceSnaps
//
//  Created by Patrick Montalto on 1/29/17.
//  Copyright © 2017 Patrick Montalto. All rights reserved.
//

import UIKit

class TimeView: UICollectionReusableView {


    @IBOutlet private var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setTimeLabel(timeCreated: Date) {
        timeLabel.text = Timer.timeAgoSinceDate(date: timeCreated as NSDate, numericDates: true).uppercased()
    }
    
}
