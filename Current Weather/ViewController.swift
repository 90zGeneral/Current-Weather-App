//
//  ViewController.swift
//  Current Weather
//
//  Created by Roydon Jeffrey on 7/1/16.
//  Copyright © 2016 Italyte. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //Connect all UI items to be modified while app in use
    @IBOutlet var cityTextField: UITextField!
    @IBOutlet var weatherSummaryLabel: UILabel!
    @IBOutlet var cityNameLabel: UILabel!
    @IBAction func findWeather(sender: AnyObject) {
        
        //Run this condition only if user enter a city name
        if cityTextField.text != "" {
            
            //Interpolate user entry into web page url
            let attemptedUrl = NSURL(string: "http://www.weather-forecast.com/locations/\(cityTextField.text!.stringByReplacingOccurrencesOfString(" ", withString: "-"))/forecasts/latest")
            
            //Execute this condition only if user entry makes a valid url along the web page url
            if let url = attemptedUrl {
                
                //getting the data from the url address. It's like opening a browser to access the web, go to the url address, get the data, give me a response or an error if necessary
                let task = NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, err) in
                    
                    //Check if data is returned and set it as the value for urlContent
                    if let urlContent = data {
                        
                        //Convert the data returned into HTML text
                        let webContent = NSString(data: urlContent, encoding: NSUTF8StringEncoding)
                        
                        //Create an array by separating the data string using a specific string contained within the data string
                        let webContentArray = webContent!.componentsSeparatedByString("3 Day Weather Forecast Summary:</b><span class=\"read-more-small\"><span class=\"read-more-content\"> <span class=\"phrase\">")
                        
                        //Execute this condition only if the array contains more than 1 items after separating the data string
                        if webContentArray.count > 1 {
                            
                            //Take the 2nd item in webContentArray and separate it using a specific string contained within it
                            let weatherSummaryArray = webContentArray[1].componentsSeparatedByString("</span></span></span></p><div")
                            
                            //Run this condition only if weatherSummaryArray now contains more than 1 items
                            if weatherSummaryArray.count > 1 {
                                
                                //Take the 1st item in weatherSummaryArray and replace a few characters within it with the degrees symbol
                                let weatherSummary = weatherSummaryArray[0].stringByReplacingOccurrencesOfString("&deg;", withString: "°")
                                
                                //Whenever a UI item is being affected, wrap it inside a dispatch closure to end the queue quickly and update UI item.
                                dispatch_async(dispatch_get_main_queue(), {
                                    
                                    //Update the UI elements
                                    self.cityNameLabel.text = self.cityTextField.text
                                    self.weatherSummaryLabel.text = weatherSummary
                                    self.weatherSummaryLabel.textColor = UIColor.greenColor()
                                    self.cityTextField.text = ""
                                    
                                })
                                
                            }
                            
                        }else {    //If webContentArray does NOT contain more than 1 items then execute this block of code
                            
                            dispatch_async(dispatch_get_main_queue(), {
                                
                                self.cityNameLabel.text = ""
                                self.weatherSummaryLabel.text = "CANNOT find that city. Check spelling"
                                self.weatherSummaryLabel.textColor = UIColor.magentaColor()
                                self.cityTextField.text = ""
                                
                            })
                            
                        }
                        
                    }
                    
                }
                
                //Allow the NSURLSession to start loading data. The task is suspended by default
                task.resume()
                
            }else {    //Execute this block of code if user entry does not make a valid URL
                
                dispatch_async(dispatch_get_main_queue(), {
                    
                    self.cityNameLabel.text = ""
                    self.weatherSummaryLabel.text = "That's NOT a city name. Try again!".capitalizedString
                    self.weatherSummaryLabel.textColor = UIColor.cyanColor()
                    self.cityTextField.text = ""
                    
                })
                
            }
            
        }else {     //Execute this block of code if textField is left blank upon button tapped 
            
            self.cityNameLabel.text = ""
            weatherSummaryLabel.text = "Please Enter a City Name".uppercaseString
            weatherSummaryLabel.textColor = UIColor.redColor()
            
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

