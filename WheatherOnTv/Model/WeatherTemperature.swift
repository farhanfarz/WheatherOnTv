//
//  WeatherTemperature.swift
//  WheatherOnTv
//
//  Created by Farhan Yousuf on 10/3/16.
//  Copyright © 2016 AlessandroGiacomella. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class WeatherTemperature: NSManagedObject {

// Insert code here to add functionality to your managed object subclass

    class func createWithDictionary(dictionary:[NSObject:AnyObject]) -> WeatherTemperature? {
        
        let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        
        if let entityDescription =
            NSEntityDescription.entityForName("WeatherTemperature",
                                              inManagedObjectContext: managedObjectContext) {
            
            let weatherTemp = WeatherTemperature(entity: entityDescription, insertIntoManagedObjectContext: managedObjectContext)
            
            weatherTemp.temp = "\(dictionary["temp"] as! Double)"
            weatherTemp.pressure = "\(dictionary["pressure"] as! Double)"
            weatherTemp.humidity = "\(dictionary["humidity"] as! Double)"
            weatherTemp.temp_min = "\(dictionary["temp_min"] as! Double)"
            weatherTemp.temp_max = "\(dictionary["temp_max"] as! Double)"

            do {
                
                try managedObjectContext.save()
                
            }catch {
                
                //                if let err = error {
                //                    print(err.localizedFailureReason)
                //                }
            }
            
            return weatherTemp
            
        }
        
        return nil
    }
    
}
