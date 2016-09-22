//
//  WeatherLocation+CoreDataProperties.swift
//  WheatherOnTv
//
//  Created by Focaloid Technologies Pvt. Ltd on 20/09/16.
//  Copyright © 2016 AlessandroGiacomella. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension WeatherLocation {

    @NSManaged var name: String?
    @NSManaged var coordinates_lat: NSNumber?
    @NSManaged var coordinates_lon: NSNumber?
    @NSManaged var city_id: NSNumber?

}
