//
//  CountableEnumeration.swift
//  TramTracker
//
//  Created by r00tdvd on 16/7/19 Copyright © 2019. All rights reserved.
//

public protocol CountableEnumeration {

    static var count: Int { get }
}

public extension CountableEnumeration where Self: RawRepresentable, Self.RawValue == Int {

    static var count: Int {
        var _count = 0
        while Self(rawValue: _count) != nil { _count += 1 }
        return _count
    }
}
