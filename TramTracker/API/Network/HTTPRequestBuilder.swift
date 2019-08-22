//
//  HTTPRequestBuilder.swift
//  TramTracker
//
//  Created by r00tdvd on 16/7/19 Copyright © 2019. All rights reserved.
//

public struct HTTPRequest {
    public var urlPath: String
    public var httpMethod: HTTPMethod
    public var httpHeaders: HTTPHeaders
    public var parameters: HTTPParameters?
    public var body: JSONBody?
}

public protocol HTTPRequestBuilderType {
    func addPath(_ path: String) -> HTTPRequestBuilderType
    func addMethod(_ method: HTTPMethod) -> HTTPRequestBuilderType
    func addHeaders(_ headers: HTTPHeaders) -> HTTPRequestBuilderType
    func addBody(_ body: JSONBody) -> HTTPRequestBuilderType
    func build() -> HTTPRequest
}

public final class HTTPRequestBuilder: HTTPRequestBuilderType {
  init() {
    // default values
    path = .empty
    method = .get
  }

  // MARK: - HTTPRequestBuilderType Conformance

  public func addPath(_ path: String) -> HTTPRequestBuilderType {
    self.path = path
    return self
  }

  public func addMethod(_ method: HTTPMethod) -> HTTPRequestBuilderType {
    self.method = method
    return self
  }

  public func addHeaders(_ headers: HTTPHeaders) -> HTTPRequestBuilderType {
    self.headers = headers
    return self
  }


  public func addBody(_ body: JSONBody) -> HTTPRequestBuilderType {
    self.body = body
    return self
  }


  public func build() -> HTTPRequest {
    return HTTPRequest(urlPath: path,
                       httpMethod: method,
                       httpHeaders: headers,
                       parameters: parameters,
                       body: body)
  }

  // MARK: - Private

  // MARK: Properties

  var path: String
  var method: HTTPMethod
  var headers: HTTPHeaders = [:]
  var parameters: HTTPParameters?
  var body: JSONBody?
}
