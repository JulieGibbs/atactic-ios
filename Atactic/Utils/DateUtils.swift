//
//  DateUtils.swift
//  Atactic
//
//  Created by Jaime on 15/3/18.
//  Copyright © 2018 ATACTIC. All rights reserved.
//

import Foundation

class DateUtils {
    
    static let defaultDateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    static let defaultDateFormatWithMiliseconds = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    
    static let defaultLocale = "es"
    static let defaultTimeZone = "Europe/Madrid"
    
    static let defaultOutputFormat = "dd/MM/yyyy HH:MM"
    
    //
    // Parses a Date from a String containing a date and time description.
    //
    // Tries to parse with the default format used by Atactic: "yyyy-MM-dd'T'HH:mm:ssZ"
    // If this doesnt' work, it tries with other common date-time formats.
    // In case it's unable to parse the date, returns nil
    //
    static func parseDate(dateString: String) -> Date? {
        
        print("DateParser - Trying to parse \(dateString)")
        
        // Remove miliseconds
        let trimmedIsoString = dateString.replacingOccurrences(of: "\\.\\d+", with: "", options: .regularExpression)
        
        // Instantiate formatter and set default locale
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: defaultLocale)
        formatter.timeZone = TimeZone(identifier: defaultTimeZone)
        
        formatter.dateFormat = defaultDateFormat
        if let parsedDate = formatter.date(from: trimmedIsoString) {
            print("DateParser - Date parsed with format \(defaultDateFormat)")
            return parsedDate
        } else {
            formatter.dateFormat = defaultDateFormatWithMiliseconds
            if let parsedDate = formatter.date(from: trimmedIsoString){
                print("DateParser - Date parsed with format \(defaultDateFormatWithMiliseconds)")
                return parsedDate
            }
        }
        return nil
    }
    
    //
    // Parses a String representation of a Date in ISO8601 format
    //
    static func parseISODate(isoDateString: String) -> Date? {
        
        // Remove miliseconds
        let trimmedIsoString = isoDateString.replacingOccurrences(of: "\\.\\d+", with: "", options: .regularExpression)
        
        // Instantiate ISO formatter
        let isoFormatter = ISO8601DateFormatter()
        if let parsedDate = isoFormatter.date(from: trimmedIsoString){
            // print("DateUtils - Date parsed with ISO formatter")
            return parsedDate
        } else {
            print("DateUtils - Unparseable ISO date: \(isoDateString)")
            return nil
        }
    }
    
    //
    // Date to String
    //
    
    static func toString(date: Date, format: String) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: defaultLocale)
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
    
    static func toDateAndTimeString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: defaultLocale)
        formatter.dateFormat = defaultOutputFormat
        return formatter.string(from: date)
    }
    
    static func toDateString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: defaultLocale)
        formatter.dateFormat = "dd/MM/yyy"
        return formatter.string(from: date)
    }
    

    //
    // Converts a string like "2018-02-06T20:51:31Z"
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

