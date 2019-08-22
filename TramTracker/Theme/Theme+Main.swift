//
//  Theme+Main.swift
//  TramTracker
//
//  Created by r00tdvd on 16/7/19 Copyright © 2019. All rights reserved.
//

import UIKit.UIColor
import UIKit.UIFont

extension Theme.Color {

  static let defaultNavigationBackground: UIColor = .clear

  static let navigationBackground: UIColor = .lightGreen

  static let navigationBarTint: UIColor = .white

  static let detailNavigationBackground: UIColor = .white

  static let detailNavigationBarTint: UIColor = .lightGreen
}

extension Theme.Font {
    static let navigationBarTitle: UIFont = UIFont(name: "MissionGothic-Regular", size: 15)!
}

extension Theme.StringAttributes {

  static var navigationTitle: [NSAttributedString.Key: Any] {
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.lineSpacing = 0.7
    paragraphStyle.alignment = .center

    return [
      .font: UIFont(name: "MissionGothic-Regular", size: 15)!,
      .kern: 1.5,
      .paragraphStyle: paragraphStyle
    ]
  }
}

extension Theme {
    static func applyAppearance(for navigationBar: UINavigationBar, theme: NavigationBarTheme) {
        switch theme {
        case .nearBy:
            navigationBar.tintColor = .white
            navigationBar.barTintColor = .lightGreen
            navigationBar.titleTextAttributes = [/*.font: Theme.Font.navigationBarTitle,*/
                                                 .foregroundColor: UIColor.white,
                                                 .kern: 1.5] as [NSAttributedString.Key: Any]
        }
    }
    

}
enum NavigationBarTheme {
    case nearBy
}
//extension Theme {
//
//  static func applyAppearance(for navigationBar: UINavigationBar, theme: NavigationBarTheme) {
//    switch theme {
//    case .lightGreen:
//      navigationBar.barStyle = .black
//      navigationBar.barTintColor = .lightGreen
//      navigationBar.tintColor = .white
//    }
//
//    navigationBar.shadowImage = UIImage()
//  }
//
//  static func applyStatusBarView(with color: UIColor) {
//    UIApplication.shared.statusBarView?.backgroundColor = color
//  }
//}
//
//enum NavigationBarTheme {
//  case lightGreen
//}
