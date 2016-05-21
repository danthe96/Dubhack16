//
//  Constant.swift
//  DubWars
//
//  Created by Daniel Thevessen on 21/05/16.
//  Copyright © 2016 Carl Julius Gödecken. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

extension String{
    func trim() -> String{
        return self.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
    }
    
    var length:Int {
        return self.characters.count
    }
    
    func removeWhitespace() -> String {
        return String(self.characters.filter({$0 != " "}))
    }
}

extension Array {
    subscript (safe index: Int) -> Element? {
        return indices ~= index ? self[index] : nil
    }
}

extension NSDate {
    
    static func timeString(fromUnixTime time: Double) -> String {
        return timeString(fromUnixTime: time, weekDay: false)
    }
    
    static func timeString(fromUnixTime time: Double, weekDay: Bool) -> String {
        let date = NSDate(timeIntervalSince1970: time)
        
        let dateFormatter1 = NSDateFormatter()
        let localizedMonth = NSDateFormatter.dateFormatFromTemplate("MMMd", options: 0, locale: NSLocale.currentLocale())
        dateFormatter1.dateFormat = weekDay ? "EEE, \(localizedMonth!)" : "\(localizedMonth!)"
        dateFormatter1.timeZone = NSTimeZone()
        
        let dateFormatter2 = NSDateFormatter()
        dateFormatter2.locale = NSLocale.systemLocale()
        dateFormatter2.dateFormat = "HH:mm"
        dateFormatter2.timeZone = NSTimeZone()
        
        return dateFormatter1.stringFromDate(date) + ", " + dateFormatter2.stringFromDate(date)
    }
}

extension Alamofire.Manager {
    public class func request(
        method: Alamofire.Method,
        URLString: URLStringConvertible,
          bodyString: String)
        -> Request
    {
        return Manager.sharedInstance.request(
            method,
            URLString,
            parameters: [:],
            encoding: .Custom({ (convertible, params) in
                let mutableRequest = convertible.URLRequest.copy() as! NSMutableURLRequest
                mutableRequest.HTTPBody = bodyString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
                return (mutableRequest, nil)
            })
        )
    }
}

// Shorthand for 0 to 255 values instead of 0 to 1
extension UIColor{
    convenience init(redInt: Int, greenInt:Int, blueInt:Int, alphaInt: Int) {
        self.init(red: CGFloat(redInt) / 255.0, green: CGFloat(greenInt) / 255.0, blue: CGFloat(blueInt) / 255.0, alpha: CGFloat(alphaInt) / 255.0)
    }
    
    convenience init(red: Int, green:Int, blue:Int){
        self.init(redInt:red, greenInt:green, blueInt:blue, alphaInt: 0xff)
    }
}
    