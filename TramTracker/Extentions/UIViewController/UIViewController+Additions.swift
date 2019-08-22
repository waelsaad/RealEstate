//
//  UIViewController+Additions.swift
//  TramTracker
//
//  Created by r00tdvd on 16/7/19 Copyright © 2019. All rights reserved.
//
import UIKit

extension UIViewController {
  
  var isViewVisible: Bool {
    return viewIfLoaded?.window != nil
  }
}
