//
//  ViewController.swift
//  WheatherOnTv
//
//  Created by Focaloid Technologies Pvt. Ltd on 18/08/16.
//  Copyright © 2016 AlessandroGiacomella. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource, CLLocationManagerDelegate {
    
    @IBOutlet weak var cityNameTextField: UITextField!
    
    @IBOutlet weak var cityNameLabel: UILabel!
    
    @IBOutlet weak var cityTempLabel: UILabel!
    @IBOutlet weak var weekCollectionView: UICollectionView!
    
    @IBOutlet weak var timeCollectionView: UICollectionView!
    
    
    @IBOutlet weak var monthYearLabel: UILabel!
    
    @IBOutlet weak var dayOfWeekLabel: UILabel!
    
    
    @IBOutlet weak var weatherTypeImage: UIImageView!
    @IBOutlet weak var hourMinuteMeridianLabel: UILabel!
    
    @IBOutlet weak var locationLabel: UILabel!
    
    
    @IBOutlet weak var cloudType: UILabel!
    
    @IBOutlet weak var degreeLabel: UILabel!
    
    @IBOutlet weak var maximumDegree: UILabel!
    
    
    @IBOutlet weak var minimumDegree: UILabel!
    var locManager = CLLocationManager()
    var locationToBeDisplayedField : String?
    var arrayOfTime : [String]?
    var arrayOfWeeks : [String]?
    var city : String?
    private var locationTitle:String = ""
    private var locationLatitude:String = ""
    private var locationLongitude:String = ""
    
    
    var locationManager: CLLocationManager = CLLocationManager()
    var startLocation: CLLocation!
    
    
    var timer : NSTimer!
    
    let apiKey:String = "eea1961c530c59ba1c9a9aca79112e3c"
    
    var openWeatherAppObject:OpenWeatherMap!
    
    
    @IBAction func getDataButtonClicked(sender: UIButton) {
        
        city = cityNameTextField.text
        print(city!)
        openWeatherAppObject.currentWeatherByCityName(city!) { (error, responseDictionary) in
            
            if error == nil {
                // UI customisations
                print(responseDictionary)
                
                if let cityName = responseDictionary!["name"] as? String {
                    
                    self.locationLabel.text = cityName
                    
                }
                
                if let temperatureDetails = responseDictionary!["main"] as? NSDictionary {
                    
                    if let tempData = temperatureDetails["temp"] as? String {
                        
                        self.degreeLabel.text = tempData
                        
                    }
                    
                    if let tempData = temperatureDetails["temp"] as? Double {
                        
                        self.degreeLabel.text = String(format: "%.1f",tempData)
                        
                    }
                    
                    if let tempData = temperatureDetails["temp_max"] as? Double {
                        
                        self.maximumDegree.text = String(tempData)
                        
                    }
                    if let tempData = temperatureDetails["temp_min"] as? Double {
                        
                        self.minimumDegree.text = String(tempData)
                        
                    }
                    
                }
                if let weatherTypeArray = responseDictionary!["weather"] as? NSArray {
                    
                    for weatherDict in weatherTypeArray {
                        
                        if let weatherTypeData = weatherDict["description"] as? String {
                            
                            self.cloudType.text = weatherTypeData
                        }
                        
                        if let weatherTypeImage = weatherDict["icon"] as? String {
                            
                            self.cityNameLabel.text = weatherTypeImage
                            
                            let weatherIcon = "http://openweathermap.org/img/w/\(weatherDict["icon"]).png"
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                self.weatherTypeImage.image = UIImage(named: weatherIcon)
                            })
                            
                            
                        }
                        
                        if let weatherImage = weatherDict["icon"] as? Int {
                            
                            self.weatherTypeImage.image = UIImage(named: String(weatherImage))
                        }
                        if let weatherImage = weatherDict["icon"] as? Double {
                            
                            
                            
                            self.weatherTypeImage.image = UIImage(named: String(weatherImage))
                        }
                        
                        
                    }
                    
                }
                
            }else {
                
                print(error)
            }
            
            
        }
        
        openWeatherAppObject.forecastWeatherByCityName(city!) { (error, responseDictionary) in
            
            if error == nil {
                // UI customisations
                if responseDictionary != nil {
                    print("\nForeCast: "+"\(responseDictionary)")
                }
                
            }else {
                print(error)
            }
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timeCollectionView.delegate = self
        timeCollectionView.dataSource = self
        
        weekCollectionView.delegate = self
        weekCollectionView.dataSource = self
        
        
        
        
        self.updateDate()
        self.timer = NSTimer(timeInterval: 1.0, target: self, selector: #selector(self.updateDate), userInfo: nil, repeats: true)
        
        arrayOfWeeks = ["Monday","Tuesday","Wendesday","Thursday","Friday","Saturday","Sunday"]
        arrayOfTime = ["9.00 am ","10.00 pm","11.00 pm","12.00 pm","8.00 pm","12.00 pm","1.00 pm"]
        
        city = "Cochin"
        openWeatherAppObject = OpenWeatherMap(APIKey: apiKey)
        
        openWeatherAppObject.setApiVersion("2.5")
        openWeatherAppObject.setTemperatureFormat(.Celcius)
        openWeatherAppObject.setLang("en")
        apiCalls()
        
        if let weekday = getDayOfWeek("2014-08-27") {
            print(weekday)
        } else {
            print("bad input")
        }
        
        
        
        
        
        
        
        let lat = 51.509865
        let lon = -0.118092
        //        let locationCordinate = CLLocationCoordinate2DMake(lat, lon)
        
        
        var currentLocation = CLLocation()
        
        
        var longitude = Double(currentLocation.coordinate.longitude)
        var latitude = Double(currentLocation.coordinate.latitude)
        let locationCordinate = CLLocationCoordinate2DMake(longitude, latitude)
        openWeatherAppObject.currentWeatherByCoordinate(locationCordinate) { (error, currentWeatherDictionary) in
            
            
            print("currentWeatherByCoordinate:\(currentWeatherDictionary)")
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
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateDate() {
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        
        let components = calendar.components([.Year,.Month,.Day,.Hour,.Minute,.Second,.Weekday], fromDate: date)
        if components.hour >= 19 || components.hour <= 6 {
            print("It's night shift")
        }
        else {
            print("It's day shift")
        }
        
        let monthName = NSDateFormatter().monthSymbols[(components.month - 1)].capitalizedString
        let dayWeekName = NSDateFormatter().weekdaySymbols[(components.weekday - 1)]
        
        let year =  components.year
        
        let timeFormatter = NSDateFormatter()
        timeFormatter.dateStyle = .NoStyle
        timeFormatter.timeStyle = .ShortStyle
        hourMinuteMeridianLabel.text = timeFormatter.stringFromDate(NSDate()).lowercaseString
        
        dayOfWeekLabel.text =  String(format: "%02ld", Int(components.day)) + " " + monthName + "," + dayWeekName  + " " + "\(year)"
        
        
    }
    
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == timeCollectionView{
            
            return arrayOfTime!.count
        }
        return arrayOfWeeks!.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        if collectionView == timeCollectionView {
            
            let timeCell = collectionView.dequeueReusableCellWithReuseIdentifier("CollectionOfTimesIdentifier", forIndexPath: indexPath) as! WTTimeCollectionViewCell
            
            timeCell.timeLabel.text = arrayOfTime![indexPath.row]
            return timeCell
            
        }
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CollectionOfWeeksIdentifier", forIndexPath: indexPath) as! WTWeeksCollectionViewCell
        
        cell.weekDaysLabel.text = arrayOfWeeks![indexPath.row]
        return cell
        
        
    }
    
}

extension ViewController {
    
    func apiCalls() {
        
        // Method 1:
        
        
        
        //
        
        //        openWeatherAppObject.currentWeatherByCityId("258730") { (error, responseDictionaryData) in
        //
        //        }
        
        
        //        let lat = 51.509865
        //        let lon = -0.118092
        //        let locationCordinate = CLLocationCoordinate2DMake(lat, lon)
        //
        //
        //
        //        openWeatherAppObject.currentWeatherByCoordinate(locationCordinate) { (error, currentWeatherDictionary) in
        //
        //
        //            print(currentWeatherDictionary)
        //        }
        
        openWeatherAppObject.forecastWeatherByCityName(city) { (error, responseDictionary) in
            
            print("forecastWeatherByCityName:\(responseDictionary)")
            
        }
        //
        //        openWeatherAppObject.forecastWeatherByCoordinate(locationCordinate) { (error, responseDictionary) in
        //
        //              print("forecastWeatherByCoordinate:\(responseDictionary)")
        //        }
        //
        openWeatherAppObject.dailyForecastWeatherByCityName(city, withCount: 7) { (error, responseDictionary) in
            
            print("dailyForecastWeatherByCityName:\(responseDictionary)")
        }
        //
        //        openWeatherAppObject.dailyForecastWeatherByCoordinate(locationCordinate, withCount: 7) { (error, responseDictionary) in
        //              print("dailyForecastWeatherByCoordinate:\(responseDictionary)")
        //        }
        //        
        //        openWeatherAppObject.searchForCityName(city) { (error, responseDictionary) in
        //            
        //             print("searchForCityName:\(responseDictionary)")
        //        }
    }
    
}

