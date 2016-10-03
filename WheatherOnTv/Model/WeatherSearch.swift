//
//  WeatherSearch.swift
//  WheatherOnTv
//
//  Created by Farhan Yousuf on 10/3/16.
//  Copyright © 2016 AlessandroGiacomella. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class WeatherSearch: NSManagedObject {

// Insert code here to add functionality to your managed object subclass

    class func createWithDictionary(dictionary:[NSObject:AnyObject]) -> WeatherSearch? {
        
        let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        
        if let entityDescription =
            NSEntityDescription.entityForName("WeatherSearch",
                                              inManagedObjectContext: managedObjectContext) {
            
            let weatherSearch = WeatherSearch(entity: entityDescription, insertIntoManagedObjectContext: managedObjectContext)
            
            if let nameString = dictionary["name"] as? String {
                
                weatherSearch.name = nameString
                
            }
            
            if (dictionary["coord"] != nil) {
                
                weatherSearch.cordinateLatitude = "\(dictionary["coord"]!["lat"]!)"
                weatherSearch.cordinateLongitude = "\(dictionary["coord"]!["lon"]!)"
                
            }
            
            if let dateTimeOfWeek = dictionary["dt_txt"] as? String {
                
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                
                weatherSearch.dateTime = dateFormatter.dateFromString(dateTimeOfWeek);
            }
            
            do {
                
                try managedObjectContext.save()
                
            }catch {
                
                //                if let err = error {
                //                    print(err.localizedFailureReason)
                //                }
            }
            
            return weatherSearch
            
        }
        
        return nil
    }
}
