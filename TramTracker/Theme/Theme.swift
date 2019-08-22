//
//  Theme.swift
//  TramTracker
//
//  Created by r00tdvd on 16/7/19 Copyright © 2019. All rights reserved.
//

import UIKit.UIColor

struct Theme {
    struct Font {}
    struct Color {}
    struct Paragraph {}
    struct StringAttributes {}
    struct Buttons {}
}

extension UIColor {
    private static func colorFrom(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) -> UIColor {
        return UIColor(red: red / 255.0, green: green / 255.0, blue: blue / 255.0, alpha: alpha)
    }
    
    static let lightGreen: UIColor = UIColor.colorFrom(red: 102, green: 198, blue: 40, alpha: 1)
}

extension Theme.Color {
    static let labelBorderColor: UIColor = .lightGreen
}

