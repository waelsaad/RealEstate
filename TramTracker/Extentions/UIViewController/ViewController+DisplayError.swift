//
//  ViewController+DisplayError.swift
//  TramTracker
//
//  Created by r00tdvd on 16/7/19 Copyright © 2019. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
  func displayError(_ title: String, message: String) {
    let alert = UIAlertController(
      title: title,
      message: message,
      preferredStyle: .alert)

    let okAction = UIAlertAction(
      title: "ALERT.OK".localized,
      style: .default,
      handler: nil)

    alert.addAction(okAction)

    present(alert, animated: true, completion: nil)
  }
}
