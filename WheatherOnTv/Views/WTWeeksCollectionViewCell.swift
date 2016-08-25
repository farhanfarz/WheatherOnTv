//
//  WTWeeksCollectionViewCell.swift
//  WheatherOnTv
//
//  Created by Focaloid Technologies Pvt. Ltd on 22/08/16.
//  Copyright © 2016 AlessandroGiacomella. All rights reserved.
//

import UIKit

class WTWeeksCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var weekView: UIView!
    
    
    @IBOutlet weak var weekDaysLabel: UILabel!
    
    @IBOutlet weak var viewWidth: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let width = viewWidth.constant/2
        weekView.layer.cornerRadius = width
    }
}
