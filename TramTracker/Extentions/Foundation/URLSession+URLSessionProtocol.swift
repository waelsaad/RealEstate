//
//  URLSession+URLSessionProtocol.swift
//  TramTracker
//
//  Created by r00tdvd on 16/7/19 Copyright © 2019. All rights reserved.
//

import Foundation

extension URLSession: URLSessionProtocol {
  public func data(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Swift.Void) {
    dataTask(with: request, completionHandler: completionHandler).resume()
  }
}
