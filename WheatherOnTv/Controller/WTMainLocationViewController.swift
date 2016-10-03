//
//  WTMainLocationViewController.swift
//  WheatherOnTv
//
//  Created by Focaloid Technologies Pvt. Ltd on 26/08/16.
//  Copyright © 2016 AlessandroGiacomella. All rights reserved.
//

import UIKit
import CoreLocation

class WTMainLocationViewController: UIViewController,CLLocationManagerDelegate {

    
    @IBOutlet weak var defaultLocation: UILabel!
    
    @IBOutlet weak var currentGPSButton: UIButton!
    
    @IBOutlet weak var manualInputButton: UIButton!
    
    @IBOutlet weak var titleContainer: UIView!
    
    @IBOutlet weak var locationSelectionContainer: UIView!
    
    @IBOutlet weak var labelLogoTitle: UILabel!
    
    var locationManager : CLLocationManager?

    var locationAuthorizationStatus:CLAuthorizationStatus!
    var window: UIWindow?

    override func viewDidLoad() {
        super.viewDidLoad()

        labelLogoTitle.text = "Weather ON"
        
        if NSUserDefaults.standardUserDefaults().objectForKey("default_location") != nil {
            self.performSegueWithIdentifier("To_Weather_Page", sender: self)
        }
        
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
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

    }
     //Location Manager helper stuff
    func initLocationManager() {

        locationManager = CLLocationManager()
        locationManager!.delegate = self
        locationManager!.desiredAccuracy = kCLLocationAccuracyBest
        
        if CLLocationManager.locationServicesEnabled(){
            
            if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.NotDetermined{
                locationManager!.requestWhenInUseAuthorization()
            }
            else if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.AuthorizedWhenInUse{
                locationManager!.requestLocation()
            }
            
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        locationManager!.stopUpdatingLocation()
        
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let locationObj = locations.last {
            let coord = locationObj.coordinate
            
            print(coord.latitude)
            print(coord.longitude)
            
            let detailController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("detailedViewController") as? ViewController
            detailController?.locationCordinate = coord
            navigationController?.pushViewController(detailController!, animated: true)
        }
        
        locationManager!.stopUpdatingLocation()
    }

    func locationManager(manager: CLLocationManager,  didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        
        var locationStatus:String = ""
        switch status {
        case CLAuthorizationStatus.Restricted:
            locationStatus = "Restricted Access to location"
        case CLAuthorizationStatus.Denied:
            locationStatus = "User denied access to location"
        case CLAuthorizationStatus.NotDetermined:
            locationStatus = "Status not determined"
        default:
            locationStatus = "Allowed to location Access"
        }
        
        print(locationStatus)
    }

    @IBAction func didTapGPSButton(sender: UIButton) {
        
        initLocationManager()
        
    }

    @IBAction func didTapManualInputButton(sender: UIButton) {
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    

}
