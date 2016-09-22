//
//  ViewController.swift
//  WheatherOnTv
//
//  Created by Focaloid Technologies Pvt. Ltd on 18/08/16.
//  Copyright © 2016 AlessandroGiacomella. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource/*, CLLocationManagerDelegate*/ {
    
    @IBOutlet weak var cityNameTextField: UITextField!
    
    @IBOutlet weak var cityNameLabel: UILabel!
    
    @IBOutlet weak var cityTempLabel: UILabel!
    @IBOutlet weak var weekCollectionView: UICollectionView!
    
    @IBOutlet weak var timeCollectionView: UICollectionView!
    
    
    @IBOutlet weak var monthYearLabel: UILabel!
    
    @IBOutlet weak var dayOfWeekLabel: UILabel!
    
    
    @IBOutlet weak var hourMinuteMeridianLabel: UILabel!
    
    @IBOutlet weak var locationLabel: UILabel!
    
    
    @IBOutlet weak var cloudType: UILabel!
    
    @IBOutlet weak var degreeLabel: UILabel!
    
    @IBOutlet weak var maximumDegree: UILabel!
    
    
    @IBOutlet weak var minimumDegree: UILabel!
    
    var locationToBeDisplayedField : String?
    var arrayOfTime : [String]?
    var arrayOfWeeks : [String]?
    var cities : String?
    
    var locationManager: CLLocationManager = CLLocationManager()
    var startLocation: CLLocation!
    
    
    var timer : NSTimer!
    
    @IBAction func getDataButtonClicked(sender: UIButton) {
        
        
        
        self.getWheatherData("http://api.openweathermap.org/data/2.5/weather?q=\(self.cityNameTextField.text)")
        
        
        print(self.getWheatherData("http://api.openweathermap.org/data/2.5/weather?q=\(self.cityNameTextField.text)"))
        
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
        
        
        //let timestamp = NSDateFormatter.localizedStringFromDate(NSDate(), dateStyle: .MediumStyle, timeStyle: .LongStyle)
        
        let timeFormatter = NSDateFormatter()
        timeFormatter.dateStyle = .NoStyle
        timeFormatter.timeStyle = .ShortStyle
        hourMinuteMeridianLabel.text = timeFormatter.stringFromDate(NSDate()).lowercaseString
        
        dayOfWeekLabel.text =  String(format: "%02ld", Int(components.day)) + " " + monthName + "," + dayWeekName  + " " + "\(year)"
        
        
    }
    
    
    //
    //     func extractData(weatherData: NSData) {
    //
    //
    //     let json = try? NSJSONSerialization.JSONObjectWithData(weatherData, options: []) as! NSDictionary
    //
    //     if json != nil {
    //     if let name = json!["name"] as? String {
    //     locationLabel.text = name
    //     }
    //
    //     if let main = json!["main"] as? NSDictionary {
    //     if let temp = main["temp"] as? Double {
    //     degreeLabel.text = String(format: "%.0f", temp)
    //     }
    //     }
    //     }
    //     }
    //
    //     func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    //     let latestLocation: AnyObject = locations[locations.count - 1]
    //
    //     let lat = latestLocation.coordinate.latitude
    //     let lon = latestLocation.coordinate.longitude
    //
    //     // Put together a URL With lat and lon
    //     let path = "http://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=2854c5771899ff92cd962dd7ad58e7b0"
    //     print(path)
    //
    //     let url = NSURL(string: path)
    //
    //     let task = NSURLSession.sharedSession().dataTaskWithURL(url!) { (data, response, error) in
    //     dispatch_async(dispatch_get_main_queue(), {
    //     self.extractData(data!)
    //     })
    //     }
    //
    //     task.resume()
    //     }
    //
    //     func locationManager(manager: CLLocationManager,
    //     didFailWithError error: NSError) {
    //
    //     }
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
        cities = "Fiesso Umbertiano"
        
        //        delay(2.0) {
        //
        //            self.getWheatherData("http://api.openweathermap.org/data/2.5/weather?q=\(self.locationToBeDisplayedField)")
        //        }
        
        
        //        print("http://api.openweathermap.org/data/2.5/weather?q=\(self.locationToBeDisplayedField)"
        
    }
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
    
    
    func getWheatherData(urlString : String){
        
        var errorType: NSError?
        let url = NSURL(string: urlString)
        
        
        
        
        
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!){(data,response,error) in
            
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
                //                temperatureData
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

