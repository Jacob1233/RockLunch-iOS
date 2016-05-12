//
//  ViewController.swift
//  RockLunch
//
//  Created by Jacob Wilson on 4/26/16.
//  Copyright © 2016 Jacob Wilson. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var refreshButton: UIBarButtonItem!
    @IBAction func refreshButtonAction(sender: AnyObject) {
        // Refresh the page
        getMenu()
    }
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        getMenu()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getMenu() {
        // Make the parameters
        var parameters: String?
        
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Day , .Month , .Year], fromDate: date)
        
        let year =  components.year
        let month = components.month
        let day = components.day
        
        parameters = "current_day=\(year)-\(month)-\(day)&adj=3"
        
        // Send the request
        // http://stackoverflow.com/questions/26364914/http-request-in-swift-with-post-method
        let request = NSMutableURLRequest(URL: NSURL(string: "http://myschooldining.com/RockhurstHighSchool/calendarWeek")!)  // change plist to allow arbitrary connections becuase http
        request.HTTPMethod = "POST"
        request.HTTPBody = parameters!.dataUsingEncoding(NSUTF8StringEncoding)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                print("error=\(error)")
                return
            }
            
            if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
            }
            
            let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding) as! String
            print("responseString = \(responseString)")
            
            // Parse then display
            dispatch_async(dispatch_get_main_queue()) { // need to escape background thread
                self.textView.text = self.parseMenu(responseString)
            }
            
        }
        task.resume()
    }
    
    func parseMenu(html: String)->String{
        
        let doc = HTML(html: html, encoding: NSUTF8StringEncoding)
        
        var arrayh4:[XMLElement] = [XMLElement]()
        
        for h4 in doc!.css("h4") {
            arrayh4.append(h4)
            
        }
        
        var arr:[String] = [String]()
        
        for h4 in arrayh4 {
            for a in h4.text!.lines {
                
                for char in a.characters {
                    if char != " " {
                        arr.append( a.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) + "\n" )
                        break
                    }
                }
                
            }
            arr.append( "\n" )
        }
        
        var str: String = ""
        for item in arr {
            // create a table with hidden expandable options to show different days on taps
            
            if item.containsString("Sunday") == true {
                
            } else if item.containsString("Monday") == true {
                
            } else if item.containsString("Tuesday") == true {
                
            } else if item.containsString("Wednesday") == true {
                
            } else if item.containsString("Thursday") == true {
                
            } else if item.containsString("Friday") == true {
                
            } else if item.containsString("Saturday") == true {
                
            } else if item.lowercaseString.containsString("no service") == true {
                
            } else if item.containsString("Lunch") == true {
                
            } else {
                
            }
            str += item
            
        }
        return str;
    }
    
}
extension String {
    
    // http://stackoverflow.com/questions/24200888/any-way-to-replace-characters-on-swift-string
    func replace(string:String, replacement:String) -> String {
        return self.stringByReplacingOccurrencesOfString(string, withString: replacement, options: NSStringCompareOptions.LiteralSearch, range: nil)
    }
    
    // http://stackoverflow.com/questions/28570973/how-should-i-remove-all-the-spaces-from-a-string-swift
    func removeWhitespace() -> String {
        return self.replace(" ", replacement: "")
    }
    
    // http://stackoverflow.com/questions/32021712/how-to-split-a-string-by-new-lines-in-swift
    var lines:[String] {
        var result:[String] = []
        enumerateLines{ result.append($0.line) }
        return result
    }
    
    // http://stackoverflow.com/questions/24034043/how-do-i-check-if-a-string-contains-another-string-in-swift
    func contains(find: String) -> Bool{
        return self.rangeOfString(find) != nil
    }
}
