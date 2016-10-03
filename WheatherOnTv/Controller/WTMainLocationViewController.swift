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
    
    var lastLocation = CLLocation()
    var locationAuthorizationStatus:CLAuthorizationStatus!
    var window: UIWindow?
   
    var seenError : Bool = false
    var locationFixAchieved : Bool = false
    var locationStatus : NSString = "Not Started"
    var locationTitle : String?
    var locationLatitude : String?
    
    var locationLongitude : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        labelLogoTitle.text = "Weather ON"
        
        initLocationManager()
        
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
        
        
//        self.initLocationManager()
        
    }
     //Location Manager helper stuff
    func initLocationManager() {
        seenError = false
        locationFixAchieved = false
        locationManager = CLLocationManager()
        locationManager!.delegate = self
        locationManager!.desiredAccuracy = kCLLocationAccuracyBest
        
//        locationManager!.requestAlwaysAuthorization()
    }
    
//    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        var current = (locations.last! as? CLLocation)
//        var defLocation = WeatherLocation()
//        
//        var openWeatherLocation = OpenWeatherMap()
//        openWeatherLocation.setCoordinates(current.coordinate)
//        var data = NSKeyedArchiver.archivedDataWithRootObject(defLocation)
//        NSUserDefaults.standardUserDefaults().setObject(data, forKey: "default_location")
//        NSUserDefaults.standardUserDefaults().synchronize()
//        self.performSegueWithIdentifier("To_Weather_Page", sender: self)
//    }
//    
////    func locationManager(manager: CLLocationManager, didFailWithError error: NSError?) {
////    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError?) {
        locationManager!.stopUpdatingLocation()
        if ((error) != nil) {
            if (seenError == false) {
                seenError = true
                print(error)
            }
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if (locationFixAchieved == false) {
            locationFixAchieved = true
            var locationArray = locations as NSArray
            var locationObj = locationArray.lastObject as! CLLocation
            var coord = locationObj.coordinate
            
            print(coord.latitude)
            print(coord.longitude)
        }
    }

    func locationManager(manager: CLLocationManager,  didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        var shouldIAllow = false
        
        switch status {
        case CLAuthorizationStatus.Restricted:
            locationStatus = "Restricted Access to location"
        case CLAuthorizationStatus.Denied:
            locationStatus = "User denied access to location"
        case CLAuthorizationStatus.NotDetermined:
            locationStatus = "Status not determined"
        default:
            locationStatus = "Allowed to location Access"
            shouldIAllow = true
        }
        NSNotificationCenter.defaultCenter().postNotificationName("LabelHasbeenUpdated", object: nil)
        if (shouldIAllow == true) {
            print("Location to Allowed")
            // Start location services
          WTLocationManager.sharedLocationManager.startUpdatingLocation()
        } else {
            print("Denied access: \(locationStatus)")
        }
    }

    @IBAction func didTapGPSButton(sender: UIButton) {
        
//     let detailController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("detailedViewController") as? ViewController
//        navigationController?.pushViewController(detailController!, animated: true)
        
        
        let placemark = WTLocationManager.sharedLocationManager.currentPlacemark
        
        if let currentPlacemark = WTLocationManager.sharedLocationManager.currentPlacemark?.subLocality
        {
            
            locationTitle = currentPlacemark
            locationLatitude = "\(placemark!.location!.coordinate.latitude)"
            locationLongitude = "\(placemark!.location!.coordinate.longitude)"
            
            
            print(locationLatitude)
            print(locationLongitude)
            
            
          
            
        }
        else if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.Denied
        {
            
            WTLocationManager.sharedLocationManager.startUpdatingLocation()
            
        }
        else
        {
            
            let alert = UIAlertController(title: "Alert", message: "Please wait while we fetch your location.", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            
        }
        
        
    }
    @IBAction func didTapManualInputButton(sender: UIButton) {
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    

}
