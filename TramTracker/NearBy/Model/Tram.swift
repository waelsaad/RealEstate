//
//  AppDelegate.swift
//  TramTracker
//
//  Created by r00tdvd on 16/7/19 Copyright © 2019. All rights reserved.
//

import Foundation

struct Tram: Codable {

    // MARK: - Properties
    let routeNumber: String?
    let destination: String?
    let predictedArrivalTime: String?
    
    // MARK: - Keys Enum
    private enum CodingKeys: String, CodingKey {
        case routeNumber = "RouteNo"
        case destination = "Destination"
        case predictedArrivalTime = "PredictedArrivalDateTime"
    }
}

extension Tram {
    var currentTimeDifference: String {
        let dateConverter = DotNetDateConverter()
        var arrivalTimeString = dateConverter.formattedDateFromString(predictedArrivalTime!)
        arrivalTimeString += (" - " + dateConverter.getTimeDifferenceStringFromCurrentTime(to: predictedArrivalTime!))
        return arrivalTimeString
    }
}

// New
struct TramServerResponse: Codable {
    var responseObject: [Tram]?
}
