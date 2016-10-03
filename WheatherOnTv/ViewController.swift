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
    var arrayOfWeeks : [String] = []
    var city : String?
    
    var locationManager: CLLocationManager = CLLocationManager()
    
    var locationCordinate:CLLocationCoordinate2D?

    var timer : NSTimer!
    
    let apiKey:String = "eea1961c530c59ba1c9a9aca79112e3c"
    
    var openWeatherAppObject:OpenWeatherMap!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        openWeatherAppObject = OpenWeatherMap(APIKey: apiKey)
        
        openWeatherAppObject.setApiVersion("2.5")
        openWeatherAppObject.setTemperatureFormat(.Celcius)
        openWeatherAppObject.setLang("en")
        
        weatherDetailsView.alpha = 0
        timeCollectionView.delegate = self
        timeCollectionView.dataSource = self
        
        weekCollectionView.delegate = self
        weekCollectionView.dataSource = self
        
        arrayOfWeeks = ["Monday","Tuesday","Wendesday","Thursday","Friday","Saturday","Sunday"]
        arrayOfTime = ["9.00 am ","10.00 pm","11.00 pm","12.00 pm","8.00 pm","12.00 pm","1.00 pm"]
        
        if let locationCord = locationCordinate {
            
            UIView.transitionWithView(weatherDetailsView, duration: 1.0, options: .AllowAnimatedContent, animations: {
                
                self.weatherDetailsView.alpha = 1
                
            }) { (true) in
                
                self.getWeatherDetailsBasedOnCordinate(locationCord)
                
            }
            
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

    }
    
    func findWeatherSearchObjectForResponseObject(responseDictionary:[NSObject:AnyObject]?) -> WeatherSearch {
        
        var weatherSearch:WeatherSearch?
        
        let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        
        if let entityDescription =
            NSEntityDescription.entityForName("WeatherSearch",
                                              inManagedObjectContext: managedObjectContext) {
            
            let request = NSFetchRequest()
            
            request.entity = entityDescription
            
            let pred = NSPredicate(format: "(%K LIKE %@)", "name","\(responseDictionary!["name"]!)")
            
            request.predicate = pred
            
            do {
                var objects = try managedObjectContext.executeFetchRequest(request)
                
                if objects.count > 0 {
                    weatherSearch = objects[0] as? WeatherSearch
                    
                } else {
                    
                    weatherSearch = WeatherSearch.createWithDictionary(responseDictionary!)!
                    
                }
                
            }catch {
                
            }
            
        }
        
        customizeWithWeatherSearch(weatherSearch!)
        
        return weatherSearch!
    }
    
    func customizeWithWeatherSearch(search:WeatherSearch) {
        
        self.locationLabel.text = search.name
        
    }
    
    func findTempInfoObjectForResponseObject(responseDictionary:[NSObject:AnyObject]?) -> WeatherTemperature {
        
        let weatherTemp:WeatherTemperature = WeatherTemperature.createWithDictionary(responseDictionary!["main"] as! [NSObject:AnyObject])!
        
        customizeWithWeatherTemperature(weatherTemp)
        
        return weatherTemp

    }
    
    func customizeWithWeatherTemperature(weatherTemperaTure:WeatherTemperature) {
        
        self.degreeLabel.text = weatherTemperaTure.temp

        self.maximumDegree.text = "Maximum: \(weatherTemperaTure.temp_max!)"
        
        self.minimumDegree.text = "Minimum: \(weatherTemperaTure.temp_min!)"
        
    }
    
    func findMainInfoWithResponseObject(responseDictionary:[NSObject:AnyObject]?) -> WeatherInfo {
        
        let weatherInfo:WeatherInfo = WeatherInfo.createWithDictionary(responseDictionary!["weather"]![0] as! [NSObject:AnyObject])!
        
        customizeWithWeatherInfo(weatherInfo)
        
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

            if let dateTimeOfWeek = responseDictionary!["dt_txt"] as? String {
                
                let dayOfWeek = "\(self.getDayOfWeek(dateTimeOfWeek))"
                self.arrayOfWeeks.append(dayOfWeek)
            }
        }
        
    }
    
    func getDayOfWeek(today:String)->Int? {
        
        let formatter  = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        if let todayDate = formatter.dateFromString(today) {
            let myCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
            let myComponents = myCalendar.components(.Weekday, fromDate: todayDate)
            let weekDay = myComponents.weekday
            return weekDay
        } else {
            return nil
        }
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
            
            return arrayOfTime!.count
        }
        return arrayOfWeeks.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        if collectionView == timeCollectionView {
            
            let timeCell = collectionView.dequeueReusableCellWithReuseIdentifier("CollectionOfTimesIdentifier", forIndexPath: indexPath) as! WTTimeCollectionViewCell
            
            timeCell.timeLabel.text = arrayOfTime![indexPath.row]
            return timeCell
            
        }
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CollectionOfWeeksIdentifier", forIndexPath: indexPath) as! WTWeeksCollectionViewCell
        
        cell.weekDaysLabel.text = arrayOfWeeks[indexPath.row]
        return cell
        
        
    }
    
}