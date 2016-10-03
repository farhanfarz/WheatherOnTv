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
            
            weatherSearch.name = "\(dictionary["name"]!)"
            if (dictionary["coord"] != nil) {
                
                weatherSearch.cordinateLatitude = "\(dictionary["coord"]!["lat"]!)"
                weatherSearch.cordinateLongitude = "\(dictionary["coord"]!["lon"]!)"
                
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
