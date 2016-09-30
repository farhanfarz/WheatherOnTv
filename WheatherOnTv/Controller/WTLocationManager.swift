//
//  WTLocationManager.swift
//  WheatherOnTv
//
//  Created by Focaloid Technologies Pvt. Ltd on 27/09/16.
//  Copyright © 2016 AlessandroGiacomella. All rights reserved.
//

import UIKit
import CoreLocation


internal typealias WTLocationUpdateCompletionHandler = (success:Bool, location:CLPlacemark?) -> Void
class WTLocationManager: NSObject, CLLocationManagerDelegate {

    
    static let sharedLocationManager = WTLocationManager()
    
    var locationManager: CLLocationManager!
    
    var currentPlacemark : CLPlacemark?
    
    var locationUpdateCompletion : WTLocationUpdateCompletionHandler?
    
    var currentLocality : String = ""
    
    override init()
    {
        super.init()
        
        locationManager = CLLocationManager()
        
    }
    func startUpdatingLocation()
    {
        
        let status : CLAuthorizationStatus = CLLocationManager.authorizationStatus()
        
        if status == .Denied {
            
            showEventsAcessDeniedAlert()
            
        }else if status == .NotDetermined {
            
            self.locationManager.requestWhenInUseAuthorization()
            
            checkAndUpdateLocation(locationUpdateCompletion)
            
        }
        else
        {
            
            checkAndUpdateLocation(locationUpdateCompletion)
            
        }
        
    }
    
    func showEventsAcessDeniedAlert()
    {
        
        let alertController = UIAlertController(title: "\"Wheather Application\" does not have access to your location",
                                                message: "To enable access, tap Settings > Location Services > On",
                                                preferredStyle: .Alert)
        
        
        let settingsAction = UIAlertAction(title: "Settings", style: .Default)
        { (alertAction) in
            
            // THIS IS WHERE THE MAGIC HAPPENS!!!!
            if let appSettings = NSURL(string: UIApplicationOpenSettingsURLString) {
                UIApplication.sharedApplication().openURL(appSettings)
            }
        }
        alertController.addAction(settingsAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        UIApplication.sharedApplication().keyWindow?.rootViewController?.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func checkAndUpdateLocation(completion:WTLocationUpdateCompletionHandler?) {
        
        if CLLocationManager.locationServicesEnabled()
        {
            
            self.locationUpdateCompletion = completion
            
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
//            locationManager.startUpdatingLocation()
        }
        
    }
    
    // MARK :- CLLocationManagerDelegate
    
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus)
    {
        
        //        KSToastView.ks_showToast("chnaged location status")
        
        if status == CLAuthorizationStatus.Denied
        {
            print("denied status")
        }
        else if status == .NotDetermined
        {
            print("not determined status")
            
        }
        else
        {
            print("accepted status")
            
        }
        
        
        
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        
        CLGeocoder().reverseGeocodeLocation(manager.location!, completionHandler: {(placemarks, error) -> Void in
            
            
            print("manager location : \(manager.location)")
            
            if error != nil
            {
                print("Reverse geocoder failed with error" + error!.localizedDescription)
                
                if self.locationUpdateCompletion != nil
                {
                    self.locationUpdateCompletion!(success: false, location: nil)
                }
                
                return
            }
            
            if placemarks!.count > 0
            {
                let pm = placemarks![0]
                print(pm.locality)
                
                self.currentPlacemark = pm
                
                if self.locationUpdateCompletion != nil
                {
                    self.locationUpdateCompletion!(success: true, location: self.currentPlacemark)
                }
            }
            else
            {
                print("Problem with the data received from geocoder")
            }
        })
        
        manager.stopUpdatingLocation()
    }
    


}
