//
//  WTLocationSearchViewController.swift
//  WheatherOnTv
//
//  Created by Focaloid Technologies Pvt. Ltd on 05/09/16.
//  Copyright © 2016 AlessandroGiacomella. All rights reserved.
//

import UIKit

class WTLocationSearchViewController: UIViewController {

    var baseUrl : String?
    var apikey : String?
    
    @IBOutlet weak var locationSerachField: UITextField!
    
    @IBOutlet weak var autocompleteTableView: UITableView!
   

    override func viewDidLoad() {
        super.viewDidLoad()
      
    }
    
    @IBAction func didTapGetLocation(sender: UIButton) {
        
//        let detailedVC = storyboard?.instantiateViewControllerWithIdentifier("detailedViewController") as? ViewController
//        
//        detailedVC?.locationToBeDisplayedField = locationSerachField.text
//        navigationController?.pushViewController(detailedVC!, animated: true)
    }
   
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        
//       
//        if segue.identifier == "detailedVCIdentifier" {
//            
//            let detailedVC = segue.destinationViewController as? ViewController
//            
//            detailedVC?.locationToBeDisplayedField = locationSerachField.text
//        }
//    }
   }

    


