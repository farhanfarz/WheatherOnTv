//
//  WeatherInfo.swift
//  WheatherOnTv
//
//  Created by Farhan Yousuf on 10/3/16.
//  Copyright © 2016 AlessandroGiacomella. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class WeatherInfo: NSManagedObject {

// Insert code here to add functionality to your managed object subclass

    class func createWithDictionary(dictionary:[NSObject:AnyObject]) -> WeatherInfo? {
        
        let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        
        if let entityDescription =
            NSEntityDescription.entityForName("WeatherInfo",
                                              inManagedObjectContext: managedObjectContext) {
            
            let weatherInfo = WeatherInfo(entity: entityDescription, insertIntoManagedObjectContext: managedObjectContext)

            weatherInfo.main = "\(dictionary["main"]!)"
            weatherInfo.detailedDescription = "\(dictionary["description"]!)"
            weatherInfo.icon = "\(dictionary["icon"]!)"
            
            do {
                
                try managedObjectContext.save()
                
            }catch {
                
//                if let err = error {
//                    print(err.localizedFailureReason)
//                }
            }
            
            return weatherInfo
            
        }
        
        return nil
    }
}
