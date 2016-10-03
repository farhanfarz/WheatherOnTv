//
//  WeatherTemperature+CoreDataProperties.swift
//  WheatherOnTv
//
//  Created by Farhan Yousuf on 10/3/16.
//  Copyright © 2016 AlessandroGiacomella. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension WeatherTemperature {

    @NSManaged var temp: String?
    @NSManaged var pressure: String?
    @NSManaged var humidity: String?
    @NSManaged var temp_min: String?
    @NSManaged var temp_max: String?

}
