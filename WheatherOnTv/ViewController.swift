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
    
    var locationToBeDisplayedField : String?
    var arrayOfTime : [String]?
    var arrayOfWeeks : [String]?
    var city : String?
    
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
                            
                            self.weatherTypeImage.image = UIImage(named: weatherTypeImage)

                        }
                        
                        if let weatherImage = weatherDict["icon"] as? Int {
                            
                             self.weatherTypeImage.image = UIImage(named: String(weatherImage))
                        }
                        if let weatherImage = weatherDict["icon"] as? Double {
                            
                            self.weatherTypeImage.image = UIImage(named: String(weatherImage))
                        }
                        
                        
                    }
                    
                }
                
                /*
                 [base: stations, id: 2643743, dt: 2016-09-23 07:56:18 +0000, main: {
                 humidity = 80;
                 pressure = 1025;
                 temp = "11.54000244140627";
                 "temp_max" = "15.55999145507815";
                 "temp_min" = "7.779992675781273";
                 }, coord: {
                 lat = "51.51";
                 lon = "-0.13";
                 }, wind: {
                 deg = "188.502";
                 speed = "1.72";
                 }, sys: {
                 country = GB;
                 id = 258730;
                 message = "0.0049";
                 sunrise = "2016-09-23 05:49:17 +0000";
                 sunset = "2016-09-23 17:55:00 +0000";
                 type = 3;
                 }, weather: <__NSCFArray 0x7f9c159821b0>(
                 {
                 description = "clear sky";
                 icon = 01d;
                 id = 800;
                 main = Clear;
                 }
                 )
                 , clouds: {
                 all = 0;
                 }, cod: 200, name: London, rain: {
                 }]
                 London
                 [base: stations, id: 2643743, dt: 2016-09-23 07:56:18 +0000, main: {
                 humidity = 80;
                 pressure = 1025;
                 temp = "11.54000244140627";
                 "temp_max" = "15.55999145507815";
                 "temp_min" = "7.779992675781273";
                 }, coord: {
                 lat = "51.51";
                 lon = "-0.13";
                 }, wind: {
                 deg = "188.502";
                 speed = "1.72";
                 }, sys: {
                 country = GB;
                 id = 258730;
                 message = "0.0049";
                 sunrise = "2016-09-23 05:49:17 +0000";
                 sunset = "2016-09-23 17:55:00 +0000";
                 type = 3;
                 }, weather: <__NSCFArray 0x7f9c134f1030>(
                 {
                 description = "clear sky";
                 icon = 01d;
                 id = 800;
                 main = Clear;
                 }
                 )
                 , clouds: {
                 all = 0;
                 }, cod: 200, name: London, rain: {
                 }]
                 */
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
//        city = "Fiesso Umbertiano"
        
        
        let lat = 51.509865
        //            latestLocation.coordinate.latitude
        let lon = -0.118092
        //            latestLocation.coordinate.longitude
        
        // Put together a URL With lat and lon
//        let path:String = "http://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&eea1961c530c59ba1c9a9aca79112e3c"
//        print(path)
        
        
//        delay(1.0) {
//            
//            self.getWheatherData(path)
//        }
        
        openWeatherAppObject = OpenWeatherMap(APIKey: apiKey)
        
        openWeatherAppObject.setApiVersion("2.5")
        openWeatherAppObject.setTemperatureFormat(.Celcius)
        openWeatherAppObject.setLang("en")
        
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
    
    
    
    //         func extractData(weatherData: NSData) {
    //
    //
    //         let json = try? NSJSONSerialization.JSONObjectWithData(weatherData, options: []) as! NSDictionary
    //
    //         if json != nil {
    //         if let name = json!["name"] as? String {
    //         locationLabel.text = name
    //         }
    //
    //         if let main = json!["main"] as? NSDictionary {
    //         if let temp = main["temp"] as? Double {
    //         degreeLabel.text = String(format: "%.0f", temp)
    //         }
    //         }
    //         }
    //         }
    //
    //         func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    //         let latestLocation: AnyObject = locations[locations.count - 1]
    //
    //         let lat = latestLocation.coordinate.latitude
    //         let lon = latestLocation.coordinate.longitude
    //
    //         // Put together a URL With lat and lon
    //         let path = "http://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&eea1961c530c59ba1c9a9aca79112e3c"
    //         print(path)
    //
    //         let url = NSURL(string: path)
    //
    //         let task = NSURLSession.sharedSession().dataTaskWithURL(url!) { (data, response, error) in
    //         dispatch_async(dispatch_get_main_queue(), {
    //         self.extractData(data!)
    //         })
    //         }
    //
    //         task.resume()
    //         }
    //
    //         func locationManager(manager: CLLocationManager,
    //         didFailWithError error: NSError) {
    //
    //         }
    
    
    
    func getWheatherData(urlString : String){
        
        var errorType: NSError?
        let url = NSURL(string: urlString)
        
//        var openWeatherAppObject = OpenWeatherMap()
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) { (data, response, error) in
            dispatch_async(dispatch_get_main_queue(), {
                self.setData(data!)
            })
        }
        
        task.resume()
    }
    
    
    
    func setData(wheatherData:NSData) {
        
        
        let jsonResponse = try! NSJSONSerialization.JSONObjectWithData(wheatherData, options: []) as? NSDictionary
        
        if let cityName = jsonResponse!["name"] as? String {
            
            cityNameLabel.text = cityName
            
        }
        
        if let temperatureDetails = jsonResponse!["main"] as? NSDictionary {
            
            if let tempData = temperatureDetails["temp"] as? Double {
                
                cityTempLabel.text = String(format: "%.1f",tempData)
               
                
            }
            
            
        }
        
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
        
        openWeatherAppObject.currentWeatherByCityId("1") { (error, responseDictionaryData) in
            
        }
        
        //
        
        let lat = 51.509865
        let lon = -0.118092
        let locationCordinate = CLLocationCoordinate2DMake(lat, lon)
        openWeatherAppObject.currentWeatherByCoordinate(locationCordinate) { (error, currentWeatherDictionary) in
            
        }
        
        // 
        
        openWeatherAppObject.forecastWeatherByCityName(city) { (error, responseDictionary) in
            
            
        }
        
        openWeatherAppObject.forecastWeatherByCoordinate(locationCordinate) { (error, reponseDictiuonary) in
            
        }
    }
    
}

