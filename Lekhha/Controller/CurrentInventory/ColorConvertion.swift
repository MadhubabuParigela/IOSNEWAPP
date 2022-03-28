//
//  ColorConvertion.swift
//  ConferenceSeries
//
//  Created by Omics on 11/20/19.
//  Copyright © 2019 Omics. All rights reserved.
//

import Foundation
import UIKit


func hexStringToUIColor (hex:String) -> UIColor {
    var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
    if (cString.hasPrefix("#")) {
        cString.remove(at: cString.startIndex)
    }
    
    if ((cString.count) != 6) {
        return UIColor.gray
    }
    
    var rgbValue:UInt64 = 0
    Scanner(string: cString).scanHexInt64(&rgbValue)
    
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}

func convertIntoJSONString(arrayObject: [Any]) -> String? {

    do {
        let jsonData: Data = try JSONSerialization.data(withJSONObject: arrayObject, options: [])
        if  let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue) {
            return jsonString as String
        }
        
    } catch let error as NSError {
        print("Array convertIntoJSON - \(error.description)")
    }
    return nil
}

func convertDateFormatter(date: String) -> String {
    
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "en_US_POSIX")
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"

let convertedDate = dateFormatter.date(from: date)

guard dateFormatter.date(from: date) != nil else {
//    assert(false, "no date from string")
    return ""
}
    
//    dateFormatter.dateFormat = "dd MMM yyyy "///this is what you want to convert format
    
//    dateFormatter.dateFormat = "dd/MM/yyyy"
    
    dateFormatter.dateFormat = "dd/MM/yyyy"
    dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
    let timeStamp = dateFormatter.string(from: convertedDate!)

    return timeStamp

}
func convertDateFormatter1(date: String) -> String {
    
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "en_US_POSIX")
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

let convertedDate = dateFormatter.date(from: date)

guard dateFormatter.date(from: date) != nil else {
//    assert(false, "no date from string")
    return ""
}
    
//    dateFormatter.dateFormat = "dd MMM yyyy "///this is what you want to convert format
    
//    dateFormatter.dateFormat = "dd/MM/yyyy"
    
    dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
    dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
    let timeStamp = dateFormatter.string(from: convertedDate!)

    return timeStamp

}


func convertServerDateFormatter(date: String) -> String {
    
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "en_US_POSIX")
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"

let convertedDate = dateFormatter.date(from: date)

guard dateFormatter.date(from: date) != nil else {
//    assert(false, "no date from string")
    return ""
}
    
//    dateFormatter.dateFormat = "dd MMM yyyy "///this is what you want to convert format
//    dateFormatter.dateFormat = "dd/MM/yyyy"
    
    dateFormatter.dateFormat = "dd/MM/yyyy"
    dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
    let timeStamp = dateFormatter.string(from: convertedDate!)

    return timeStamp

}

func convertDateTimeFormatter(date: String) -> String {
    
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "en_US_POSIX")
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

let convertedDate = dateFormatter.date(from: date)

guard dateFormatter.date(from: date) != nil else {
//    assert(false, "no date from string")
    return ""
}
    
//yyyy MMM dd:mm EEEE
    
    dateFormatter.dateFormat = "dd/MM/yyyy hh:mm:a"///this is what you want to convert format
    dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
    let timeStamp = dateFormatter.string(from: convertedDate!)

    return timeStamp

}
func convertDateTimeFormatter1(date: String) -> String {
//    2022-03-01T07:24:14.669Z
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
//    dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
    dateFormatter.locale = Locale(identifier: "en_US_POSIX")
//        "yyyy-MM-dd'T'HH:mm:ss.SSSZ"

let convertedDate = dateFormatter.date(from: date)

guard dateFormatter.date(from: date) != nil else {
//    assert(false, "no date from string")
    return ""
}
    
//yyyy MMM dd:mm EEEE
    
    dateFormatter.dateFormat = "dd/MM/yyyy hh:mm a"
//        "yyyy-MM-dd HH.mm"
//        "dd/MM/yyyy hh:mm a"///this is what you want to convert format
    dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
    let timeStamp = dateFormatter.string(from: convertedDate!)

    return timeStamp

}



