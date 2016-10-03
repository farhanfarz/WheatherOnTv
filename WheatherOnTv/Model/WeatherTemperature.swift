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
            
            if let tempData = dictionary["temp"] as? Double {
            
                weatherTemp.temp = String(format: "%.1f",tempData)
            
            }
            
            if let tempData = dictionary["temp_max"] as? Double {
            
                let dataToBeRounded = tempData
                let roundedData = Double(round(1000*dataToBeRounded)/1000)
                weatherTemp.temp_max = "\(roundedData)"
            
            }
            if let tempData = dictionary["temp_min"] as? Double {
                let dataToBeRounded = tempData
                let roundedData = Double(round(1000*dataToBeRounded)/1000)
                
                weatherTemp.temp_min = "\(roundedData)"
                
            }
            
//            weatherTemp.temp = "\(dictionary["temp"] as! Double)"
            weatherTemp.pressure = "\(dictionary["pressure"] as! Double)"
            weatherTemp.humidity = "\(dictionary["humidity"] as! Double)"
//            weatherTemp.temp_min = "\(dictionary["temp_min"] as! Double)"
//            weatherTemp.temp_max = "\(dictionary["temp_max"] as! Double)"

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
