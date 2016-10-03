//
//  WeatherInfo+CoreDataProperties.swift
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

extension WeatherInfo {

    @NSManaged var main: String?
    @NSManaged var detailedDescription: String?
    @NSManaged var icon: String?

}
