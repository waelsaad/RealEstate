//
//  DotNetDateConverter.swift
//  TramTracker
//
//  Created by r00tdvd on 16/7/19 Copyright © 2019. All rights reserved.
//

import Foundation

class DotNetDateConverter {
    
    // Converts the .NET date to Date
    
    func dateFromDotNetFormattedDateString(_ string: String) -> Date! {
        guard let startRange = string.range(of: "("),
            let endRange = string.range(of: "+") else { return nil }
        
        let lowBound = string.index(startRange.lowerBound, offsetBy: 1)
        let range = lowBound..<endRange.lowerBound
        
        let dateAsString = string[range]
        guard let time = Double(dateAsString) else { return nil }
        let unixTimeInterval = time / 1000
        return Date(timeIntervalSince1970: unixTimeInterval)
    }
    
    // Provides the formatted date/time string
    func formattedDateFromString(_ string: String) -> String {
        let date = dateFromDotNetFormattedDateString(string)
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date!)
    }
    
    // Provides the formatted date/time difference string
    func getTimeDifferenceStringFromCurrentTime(to:String)->String{
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute]
        if let differenceString = formatter.string(from: Date(), to: dateFromDotNetFormattedDateString(to)){
            if differenceString == "0"{return "Departed"}
            return differenceString + " Mins"
        }
        return ""
    }
    
    // Testable implementation of the upper function
    func getTimeDifferenceStringFromRefernceTime(to:String, fromDate:Date)->String{
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute]
        if let differenceString = formatter.string(from: fromDate, to: dateFromDotNetFormattedDateString(to)){
            if differenceString == "0"{return "Departed"}
            return differenceString + " Mins"
        }
        return ""
    }
}
