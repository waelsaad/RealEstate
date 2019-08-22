//
//  ViewController+NavigationBar.swift
//  TramTracker
//
//  Created by r00tdvd on 16/7/19 Copyright © 2019. All rights reserved.
//

import UIKit

extension UIViewController {

  func configureNavigationBar(with title: String?, theme: NavigationBarTheme, applyStatusBar: Bool = true) {

    if let title = title {
      navigationItem.title = title
    }
    navigationController?.navigationBar.barTintColor = .lightGreen

    guard let navigationBar = navigationController?.navigationBar else { return }
    Theme.applyAppearance(for: navigationBar, theme: theme)
  }
}
