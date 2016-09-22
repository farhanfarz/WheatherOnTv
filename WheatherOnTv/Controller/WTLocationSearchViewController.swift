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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        baseUrl = "https://maps.googleapis.com/maps/api/geocode/json?"
//        apikey  = "AIzaSyBd7proCMNWDL1HhazmCvYqirSxiWv1g3Y"
        
//        getLatLngForZip("95014")
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

//    func getLatLngForZip(zipCode: String) {
//        let url = NSURL(string: "\(baseUrl)address=\(zipCode)&key=\(apikey)")
//        let data = NSData(contentsOfURL: url!)
//        let json = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as! NSDictionary
//        if let result = json["results"] as? NSArray {
//            if let geometry = result[0]["geometry"] as? NSDictionary {
//                if let location = geometry["location"] as? NSDictionary {
//                    let latitude = location["lat"] as! Float
//                    let longitude = location["lng"] as! Float
//                    print("\n\(latitude), \(longitude)")
//                }
//            }
//        }
//    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   

}
