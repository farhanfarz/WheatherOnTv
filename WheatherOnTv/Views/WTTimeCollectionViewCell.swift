//
//  WTTimeCollectionViewCell.swift
//  WheatherOnTv
//
//  Created by Focaloid Technologies Pvt. Ltd on 23/08/16.
//  Copyright © 2016 AlessandroGiacomella. All rights reserved.
//

import UIKit

class WTTimeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var timeView: UIView!
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var viewWidth: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let width = viewWidth.constant/2
        timeView.layer.cornerRadius = width
    }

}
