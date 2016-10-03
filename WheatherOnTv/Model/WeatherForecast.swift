//
//  WeatherForecast.swift
//  WheatherOnTv
//
//  Created by Farhan Yousuf on 10/3/16.
//  Copyright © 2016 AlessandroGiacomella. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class WeatherForecast: NSManagedObject {

// Insert code here to add functionality to your managed object subclass

    class func createWithDictionary(dictionary:[NSObject:AnyObject]) -> WeatherForecast? {
        
        let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        
        if let entityDescription =
            NSEntityDescription.entityForName("WeatherForecast",
                                              inManagedObjectContext: managedObjectContext) {
            
            let weatherForeCast = WeatherForecast(entity: entityDescription, insertIntoManagedObjectContext: managedObjectContext)
            
            do {
                
                try managedObjectContext.save()
                
            }catch {
                
                //                if let err = error {
                //                    print(err.localizedFailureReason)
                //                }
            }
            
            return weatherForeCast
            
        }
        
        return nil
    }
}

extension WeatherForecast {
    func addListObject(value:WeatherSearch) {
        let items = self.mutableSetValueForKey("weatherResults");
        items.addObject(value)
    }
    
    func removeListObject(value:WeatherSearch) {
        let items = self.mutableSetValueForKey("weatherResults");
        items.removeObject(value)
    }
}