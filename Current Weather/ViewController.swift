//
//  ViewController.swift
//  Current Weather
//
//  Created by Roydon Jeffrey on 7/1/16.
//  Copyright © 2016 Italyte. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var cityTextField: UITextField!
    
    @IBOutlet var weatherSummaryLabel: UILabel!
    
    @IBAction func findWeather(sender: AnyObject) {
        
        var successfullyFound = false
        
        let attemptedUrl = NSURL(string: "http://www.weather-forecast.com/locations/\(cityTextField.text!.stringByReplacingOccurrencesOfString(" ", withString: "-"))/forecasts/latest")
        
        if let url = attemptedUrl {
        
            let task = NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, err) in
            
                if let urlContent = data {
                
                    let webContent = NSString(data: urlContent, encoding: NSUTF8StringEncoding)
                
                    let webContentArray = webContent!.componentsSeparatedByString("3 Day Weather Forecast Summary:</b><span class=\"read-more-small\"><span class=\"read-more-content\"> <span class=\"phrase\">")
                
                    if webContentArray.count > 1 {
                    
                        let weatherSummaryArray = webContentArray[1].componentsSeparatedByString("</span></span></span></p><div")
                    
                        if weatherSummaryArray.count > 1 {
                            
                            successfullyFound = true
                        
                            let weatherSummary = weatherSummaryArray[0]
                        
                            let result = weatherSummary.stringByReplacingOccurrencesOfString("&deg;", withString: "°")
                        
                            //Whenever a UI item is being affected, wrap it inside a dispatch closure to end the queue quickly and update UI item.
                            dispatch_async(dispatch_get_main_queue(), {
                                
                                self.weatherSummaryLabel.text = result
                                self.cityTextField.text = ""
                                
                            })
        
                        }
                    
                    }
                
                }
            
            }
            
            task.resume()
            
        }else {
            
            dispatch_async(dispatch_get_main_queue(), {
                
                self.weatherSummaryLabel.text = "That's NOT a city name. Try again!"
                self.cityTextField.text = ""
                
            })
            
        }
        
        if self.cityTextField.text == "" {
            
            weatherSummaryLabel.text = "Please Enter a City Name"
            
        }else if successfullyFound == false {
            
            dispatch_async(dispatch_get_main_queue(), {
                self.weatherSummaryLabel.text = "City name NOT found. Maybe check spelling and try again."
            })
            
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

