//
//  APIEndpoints.swift
//  TramTracker
//
//  Created by r00tdvd on 16/7/19 Copyright © 2019. All rights reserved.
//

import Foundation

var token: Token?
var baseURL = "http://ws3.tramtracker.com.au/TramTracker/RestService"

// MARK: - Protocol to provide string by concatinating base URL
public protocol EndpointsConfiguration {
    func absoluteURL() -> String
}

enum Endpoint: EndpointsConfiguration {
    
    // MARK: - Endpoints
    case fetchToken,
    
    fetchTrams(token:String, stopId:String)
    
    func absoluteURL() -> String {
        var servicePath = String.empty
        switch (self) {
        case .fetchToken:
            servicePath = "/GetDeviceToken/?aid=TTIOSJSON&devInfo=HomeTimeiOS"
        case .fetchTrams(let token,let stopId):
            servicePath = "/GetNextPredictedRoutesCollection/\(stopId)/78/false/?aid=TTIOSJSON&cid=2&tkn=\(token)"
        }
        return baseURL + servicePath
    }
}
