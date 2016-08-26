//
//  WTMainLocationViewController.swift
//  WheatherOnTv
//
//  Created by Focaloid Technologies Pvt. Ltd on 26/08/16.
//  Copyright © 2016 AlessandroGiacomella. All rights reserved.
//

import UIKit

class WTMainLocationViewController: UIViewController {

    
    @IBOutlet weak var defaultLocation: UILabel!
    
    @IBOutlet weak var currentGPSButton: UIButton!
    
    
    @IBOutlet weak var manualInputButton: UIButton!
    
    
    @IBOutlet weak var titleContainer: UIView!
    
    @IBOutlet weak var locationSelectionContainer: UIView!
    
    @IBOutlet weak var labelLogoTitle: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        labelLogoTitle.text = "Weather ON"
        
    }
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        
        UIView.animateWithDuration(1.0, animations: {() -> Void in
            var titleRect = self.titleContainer.frame
            titleRect.origin.x = 0
            self.titleContainer.frame = titleRect
            var locationSelectionRect = self.locationSelectionContainer.frame
            locationSelectionRect.origin.x -= locationSelectionRect.size.width
            self.locationSelectionContainer.frame = locationSelectionRect
        })

        
    }
    @IBAction func didTapGPSButton(sender: UIButton) {
        
     let detailController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("detailedViewController") as? ViewController
        navigationController?.pushViewController(detailController!, animated: true)
    }
    @IBAction func didTapManualInputButton(sender: UIButton) {
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    

}
