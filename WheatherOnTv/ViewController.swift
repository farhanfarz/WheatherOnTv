//
//  ViewController.swift
//  WheatherOnTv
//
//  Created by Focaloid Technologies Pvt. Ltd on 18/08/16.
//  Copyright © 2016 AlessandroGiacomella. All rights reserved.
//

import UIKit
import CoreLocation
import CoreData

class ViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource, CLLocationManagerDelegate {
    
    @IBOutlet weak var cityNameTextField: UITextField!
    
    @IBOutlet weak var weekCollectionView: UICollectionView!
    
    @IBOutlet weak var timeCollectionView: UICollectionView!
    
    @IBOutlet weak var dayOfWeekLabel: UILabel!
    
    @IBOutlet weak var weatherTypeImage: UIImageView!
    
    @IBOutlet weak var hourMinuteMeridianLabel: UILabel!
    
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var cloudType: UILabel!
    
    @IBOutlet weak var degreeLabel: UILabel!
    
    @IBOutlet weak var maximumDegree: UILabel!
    
    @IBOutlet weak var minimumDegree: UILabel!
    
    @IBOutlet weak var weatherDetailsView: UIView!
    
    @IBOutlet weak var getCityDetailsButton: UIButton!

    var arrayOfTime : [String]?
    var arrayOfWeeks : [NSDate] = []
    var city : String?
    
    var locationManager: CLLocationManager = CLLocationManager()
    
    var locationCordinate:CLLocationCoordinate2D?

    var timer : NSTimer!
    
    let apiKey:String = "eea1961c530c59ba1c9a9aca79112e3c"
    
    var openWeatherAppObject:OpenWeatherMap!
    
    var weatherSearch:WeatherSearch?
    
    var weatherForeCast:WeatherForecast?
    
    var arrayWeatherSearchResultsInSelectedDay:[WeatherSearch] = [WeatherSearch]()
    
    let timeFormatter = NSDateFormatter()
    
    var currentDate:NSDate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        purgeAllData()
        
        openWeatherAppObject = OpenWeatherMap(APIKey: apiKey)
        
        openWeatherAppObject.setApiVersion("2.5")
        openWeatherAppObject.setTemperatureFormat(.Celcius)
        openWeatherAppObject.setLang("en")
        
        weatherDetailsView.alpha = 0
        timeCollectionView.delegate = self
        timeCollectionView.dataSource = self
        
        weekCollectionView.delegate = self
        weekCollectionView.dataSource = self
        
        currentDate = NSDate()
        let calender = NSCalendar.currentCalendar()
        let offset = NSDateComponents()
        arrayOfWeeks = [currentDate!]
        
        for i in 1...6 {
            offset.day = i
            let nextDay = calender.dateByAddingComponents(offset, toDate: currentDate!, options: .WrapComponents)
            arrayOfWeeks.append(nextDay!)
        }
        
        timeFormatter.dateStyle = .NoStyle
        timeFormatter.timeStyle = .MediumStyle
        
        if let locationCord = locationCordinate {
            
            UIView.transitionWithView(weatherDetailsView, duration: 1.0, options: .AllowAnimatedContent, animations: {
                
                self.weatherDetailsView.alpha = 1
                
            }) { (true) in
                
                self.getWeatherDetailsBasedOnCordinate(locationCord)
                
            }
            
        }
        
    }
    
    func purgeAllData() {
        
        let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        
        let myPersistentStoreCoordinator = (UIApplication.sharedApplication().delegate as! AppDelegate).persistentStoreCoordinator
        
        let fetchRequestWeatherSearch = NSFetchRequest(entityName: "WeatherSearch")
        let fetchRequestWeatherTemp = NSFetchRequest(entityName: "WeatherTemperature")
        let fetchRequestWeatherInfo = NSFetchRequest(entityName: "WeatherInfo")
        let fetchRequestWeatherForeCast = NSFetchRequest(entityName: "WeatherForecast")
        
        let deleteRequestWeatherSearch = NSBatchDeleteRequest(fetchRequest: fetchRequestWeatherSearch)
        let deleteRequestWeatherTemp = NSBatchDeleteRequest(fetchRequest: fetchRequestWeatherTemp)
        let deleteRequestWeatherInfo = NSBatchDeleteRequest(fetchRequest: fetchRequestWeatherInfo)
        let deleteRequestWeatherForeCast = NSBatchDeleteRequest(fetchRequest: fetchRequestWeatherForeCast)
        
        do {
            
            try myPersistentStoreCoordinator.executeRequest(deleteRequestWeatherSearch, withContext: managedObjectContext)
            try myPersistentStoreCoordinator.executeRequest(deleteRequestWeatherTemp, withContext: managedObjectContext)
            try myPersistentStoreCoordinator.executeRequest(deleteRequestWeatherInfo, withContext: managedObjectContext)
            try myPersistentStoreCoordinator.executeRequest(deleteRequestWeatherForeCast, withContext: managedObjectContext)
            
        } catch let error as NSError {
            // TODO: handle the error
        }
        
    }
    
    func getWeatherDetailsBasedOnCordinate(locationCord:CLLocationCoordinate2D) {
        
        self.openWeatherAppObject.currentWeatherByCoordinate(locationCord) { (error, currentWeatherDictionary) in
            
            print("currentWeatherByCoordinate:\(currentWeatherDictionary)")
            
            if error == nil {
                
                self.customizeWithWeatherInfoDictionary(currentWeatherDictionary)
                
            }else {
                
                print(error)
            }
            
        }
        
        self.openWeatherAppObject.forecastWeatherByCoordinate(locationCord) { (error, responseDictionary) in
            
            if error == nil {
                // UI customisations
                
                self.customizeForForeCast(responseDictionary)
                
            }else {
                print(error)
            }
            
        }
        
    }
    
    func getWeatherBasedOnCity() {
        
        self.openWeatherAppObject.currentWeatherByCityName(self.city!) { (error, responseDictionary) in
            
            if error == nil {
                
                self.customizeWithWeatherInfoDictionary(responseDictionary)
                
            }else {
                
                print(error)
            }
            
        }
        
        self.openWeatherAppObject.forecastWeatherByCityName(self.city!) { (error, responseDictionary) in
            
            if error == nil {
                // UI customisations
                
                self.customizeForForeCast(responseDictionary)
                
            }else {
                print(error)
            }
            
        }
        
    }
    
    @IBAction func getCityWeatherData(sender: UIButton) {
        
        UIView.transitionWithView(weatherDetailsView, duration: 1.0, options: .AllowAnimatedContent, animations: {
            
            self.weatherDetailsView.alpha = 1
            
        }) { (true) in
            
            self.city = self.cityNameTextField.text
            
            self.getWeatherBasedOnCity()
        }
        
    }
    
    func customizeWithWeatherInfoDictionary(responseDictionary:[NSObject:AnyObject]?) {
        
        // UI customisations
        print(responseDictionary)
        
        let weatherSearch:WeatherSearch = findWeatherSearchObjectForResponseObject(responseDictionary)
        
        weatherSearch.tempInfo = findTempInfoObjectForResponseObject(responseDictionary)
        
        weatherSearch.mainInfo = findMainInfoWithResponseObject(responseDictionary)

        customizeAllTheViewsWithWeatherSearch(weatherSearch)
    }

    func customizeAllTheViewsWithWeatherSearch(weatherSearch:WeatherSearch) {
        
        customizeWithWeatherSearch(weatherSearch)
        customizeWithWeatherTemperature(weatherSearch.tempInfo!)
        customizeWithWeatherInfo(weatherSearch.mainInfo!)
        
    }
    
    func findWeatherSearchObjectForResponseObject(responseDictionary:[NSObject:AnyObject]?) -> WeatherSearch {
        
        let weatherSearch = WeatherSearch.createWithDictionary(responseDictionary!)!
        
//        let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
//        
//        if let entityDescription =
//            NSEntityDescription.entityForName("WeatherSearch",
//                                              inManagedObjectContext: managedObjectContext) {
//            
//            let request = NSFetchRequest()
//            
//            request.entity = entityDescription
//            
//            let pred = NSPredicate(format: "(%K LIKE %@)", "name","\(responseDictionary!["name"]!)")
//            
//            request.predicate = pred
//            
//            do {
//                var objects = try managedObjectContext.executeFetchRequest(request)
//                
//                if objects.count > 0 {
//                    weatherSearch = objects[0] as? WeatherSearch
//                    
//                } else {
//                    
//                    weatherSearch = WeatherSearch.createWithDictionary(responseDictionary!)!
//                    
//                }
//                
//            }catch {
//                
//            }
//            
//        }
//        
//        
//        
        return weatherSearch
    }
    
    func customizeWithWeatherSearch(search:WeatherSearch) {
        
        self.locationLabel.text = search.name
        
    }
    
    func findTempInfoObjectForResponseObject(responseDictionary:[NSObject:AnyObject]?) -> WeatherTemperature {
        
        let weatherTemp:WeatherTemperature = WeatherTemperature.createWithDictionary(responseDictionary!["main"] as! [NSObject:AnyObject])!
        
        return weatherTemp

    }
    
    func customizeWithWeatherTemperature(weatherTemperaTure:WeatherTemperature) {
        
        self.degreeLabel.text = weatherTemperaTure.temp! + "°C"

        self.maximumDegree.text = "Maximum: \(weatherTemperaTure.temp_max!)"
        
        self.minimumDegree.text = "Minimum: \(weatherTemperaTure.temp_min!)"
        
    }
    
    func findMainInfoWithResponseObject(responseDictionary:[NSObject:AnyObject]?) -> WeatherInfo {
        
        let weatherInfo:WeatherInfo = WeatherInfo.createWithDictionary(responseDictionary!["weather"]![0] as! [NSObject:AnyObject])!
        
        return weatherInfo
        
    }
    
    func customizeWithWeatherInfo(weatherInfo:WeatherInfo) {
        
        self.cloudType.text = weatherInfo.detailedDescription
 
        let weatherIcon = "http://openweathermap.org/img/w/\(weatherInfo.icon!).png"
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            if let data = NSData(contentsOfURL: NSURL(string: weatherIcon)!) {
                self.weatherTypeImage.image = UIImage(data: data)
            }
            
        })
        
    }
    
    func customizeForForeCast(responseDictionary:[NSObject:AnyObject]?) {
        
        if responseDictionary != nil {
            print("\nForeCast: "+"\(responseDictionary)")

            let foreCast = WeatherForecast.createWithDictionary(responseDictionary!);
            
            for foreCastDictionary in responseDictionary!["list"] as! [[NSObject:AnyObject]] {
                
                let weatherSearch:WeatherSearch = findWeatherSearchObjectForResponseObject(foreCastDictionary)
                
                weatherSearch.tempInfo = findTempInfoObjectForResponseObject(foreCastDictionary)
                
                weatherSearch.mainInfo = findMainInfoWithResponseObject(foreCastDictionary)
                
                foreCast?.addListObject(weatherSearch)
            }
            
            self.getTimeLinesForDate(currentDate!)
            
        }
        
    }
    
    func getDayOfWeek(date:NSDate) -> Int? {
        
        let myCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        let myComponents = myCalendar.components(.Weekday, fromDate: date)
        let weekDay = myComponents.weekday
        return weekDay
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == timeCollectionView{
            
            return arrayWeatherSearchResultsInSelectedDay.count
        }
        return arrayOfWeeks.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        if collectionView == timeCollectionView {
            
            let timeCell = collectionView.dequeueReusableCellWithReuseIdentifier("CollectionOfTimesIdentifier", forIndexPath: indexPath) as! WTTimeCollectionViewCell
            
            let weatherSearchItem:WeatherSearch = arrayWeatherSearchResultsInSelectedDay[indexPath.row]
            
            timeCell.timeLabel.text = timeFormatter.stringFromDate(weatherSearchItem.dateTime!)
            
//            timeCell.timeLabel.text = arrayOfTime![indexPath.row]
            return timeCell
            
        }
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CollectionOfWeeksIdentifier", forIndexPath: indexPath) as! WTWeeksCollectionViewCell
        
        if (arrayOfWeeks[indexPath.row].compare(currentDate!) == .OrderedSame) {
            
            cell.weekDaysLabel.textColor = UIColor.greenColor()
            
        }else {
            
            cell.weekDaysLabel.textColor = UIColor.whiteColor()
            
        }
        
        let indexWeekDay = getDayOfWeek(arrayOfWeeks[indexPath.row])!

        cell.weekDaysLabel.text = timeFormatter.weekdaySymbols[indexWeekDay-1]
        
        return cell
        
        
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        if collectionView == timeCollectionView {
            
            let weatherSearchItem:WeatherSearch = arrayWeatherSearchResultsInSelectedDay[indexPath.row]

            customizeAllTheViewsWithWeatherSearch(weatherSearchItem)
            
        }else {
            
            self.getTimeLinesForDate(arrayOfWeeks[indexPath.row])
            
        }
    }
    
    
    func getTimeLinesForDate(date:NSDate) {
        
        let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        
        if let entityDescription =
            NSEntityDescription.entityForName("WeatherSearch",
                                              inManagedObjectContext: managedObjectContext) {
            
            let request = NSFetchRequest()
            
            request.entity = entityDescription
            
            let pred = predicateForDayFromDate(date)
            
            request.predicate = pred
            
            do {
                
                arrayWeatherSearchResultsInSelectedDay = try managedObjectContext.executeFetchRequest(request) as! [WeatherSearch]
                
                timeCollectionView.reloadData()
                
                currentDate = date
                
                weekCollectionView.reloadData()
                
            }catch {
                
            }
            
        }
        
    }
    
    func predicateForDayFromDate(date: NSDate) -> NSPredicate {
        let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
        let components = calendar!.components([.Year, .Month, .Day, .Hour, .Minute, .Second], fromDate: date)
        components.hour = 00
        components.minute = 00
        components.second = 00
        let startDate = calendar!.dateFromComponents(components)
        components.hour = 23
        components.minute = 59
        components.second = 59
        let endDate = calendar!.dateFromComponents(components)
        
        return NSPredicate(format: "dateTime >= %@ AND dateTime =< %@", argumentArray: [startDate!, endDate!])
    }
}