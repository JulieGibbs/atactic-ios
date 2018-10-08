//
//  DateUtils.swift
//  Atactic
//
//  Created by Jaime on 15/3/18.
//  Copyright © 2018 ATACTIC. All rights reserved.
//

import Foundation

class DateUtils {
    
    static let defaultRawDateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    static let defaultLocale = "es"
    static let defaultOutputFormat = "dd/MM/yyyy HH:MM"
    
    //
    // Parses a Date from a String containing a date and time description
    // in the default format used by Atactic: "yyyy-MM-dd'T'HH:mm:ssZ"
    //
    static func parseDate(dateString: String) -> Date? {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: defaultLocale)
        formatter.dateFormat = defaultRawDateFormat
        return formatter.date(from: dateString)
    }
    
    static func toDateAndTimeString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: defaultLocale)
        formatter.dateFormat = defaultOutputFormat
        return formatter.string(from: date)
    }
    
    //
    // Converts to a string like "2018-02-06T20:51:31Z"
    // to a string like "06/02/2018 20:51:31"
    //
    static func toFormattedDateAndTime(unformattedTimeStamp: String) -> String {
        
        let dateSubstr = String(unformattedTimeStamp.split(separator: "T")[0])
        var timeSubstr = String(unformattedTimeStamp.split(separator: "T")[1])
        
        let sourceFormatter = DateFormatter()
        sourceFormatter.dateFormat = "yyyy-MM-dd"
        let parsedDate = sourceFormatter.date(from: dateSubstr)
        let printableFormatter = DateFormatter()
        printableFormatter.dateFormat = "dd'/'M'/'yyyy"
        
        let parsedDateStr = printableFormatter.string(from: parsedDate!)    // 06/02/2018
        
        timeSubstr.remove(at: timeSubstr.index(before: timeSubstr.endIndex))    // Remove last char
        
        return parsedDateStr + " " + timeSubstr
    }
    
    //
    // Converts to a string like "2018-02-06T20:51:31Z..."
    // to a string like "06/02/2018"
    //
    static func toFormattedDate(timestamp: String) -> String {
        let dateSubstr = String(timestamp.split(separator: "T")[0])
        
        let sourceFormatter = DateFormatter()
        sourceFormatter.dateFormat = "yyyy-MM-dd"
        let parsedDate = sourceFormatter.date(from: dateSubstr)
        let printableFormatter = DateFormatter()
        printableFormatter.dateFormat = "dd'/'M'/'yyyy"
        
        return printableFormatter.string(from: parsedDate!)
    }
    
    
}

