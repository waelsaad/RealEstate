//
//  AppPreferences.swift
//  TramTracker
//
//  Created by r00tdvd on 16/7/19 Copyright © 2019. All rights reserved.
//

import Foundation

protocol AppPreferencesType {
    
    var userToken: String { get }
}

// AppPreferences is responsible for accessing values from UserDefaults.
class AppPreferences: AppPreferencesType {
    
    // MARK: - Properties
    static let shared = AppPreferences.init()
    
    private let standardDefaults = UserDefaults.standard

    var userToken: String {
        return standardDefaults.string(forKey: Keys.tokenKey.rawValue) ?? String.empty
    }
    
    // MARK: - Initializer
    private init(){}


    // MARK: - Methods
    func saveTokenLocally(token:String) {
        standardDefaults.set(token, forKey: Keys.tokenKey.rawValue)
        standardDefaults.synchronize()
    }
}

extension AppPreferences {
    private enum Keys: String {
        case tokenKey
    }
}
