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
        
        
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let url = NSURL(string: "http://www.weather-forecast.com/locations/Brooklyn/forecasts/latest")!
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, err) in
            
            if let urlContent = data {
                
                let webContent = NSString(data: urlContent, encoding: NSUTF8StringEncoding)
                
                let webContentArray = webContent?.componentsSeparatedByString("3 Day Weather Forecast Summary:</b><span class=\"read-more-small\"><span class=\"read-more-content\"> <span class=\"phrase\">")
                
                if webContentArray!.count > 0 {
                    
                    let weatherSummaryArray = webContentArray![1].componentsSeparatedByString("</span></span></span></p><div")
                    
                    if weatherSummaryArray.count > 0 {
                        
                        let weatherSummary = String(weatherSummaryArray[0])
                        
                        let result = weatherSummary.stringByReplacingOccurrencesOfString("&deg;", withString: "°")
                        
                        print(result)
                    }
                    
                }
                
            }
            
        }
        task.resume()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

