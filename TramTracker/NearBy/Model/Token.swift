//
//  AppDelegate.swift
//  TramTracker
//
//  Created by r00tdvd on 16/7/19 Copyright © 2019. All rights reserved.
//

import Foundation

struct Token: Codable {
    
    // MARK: - Properties
    let token: String?
    
    // MARK: - Keys Enum
    private enum CodingKeys: String, CodingKey {
        case token = "DeviceToken"
    }
}

// New
struct TokenServerResponse: Codable {
    var responseObject: [Token]
}
