//
//  HTTPClient.swift
//  TramTracker
//
//  Created by r00tdvd on 16/7/19 Copyright © 2019. All rights reserved.
//

import Foundation

public typealias JSONBody = Any
public typealias HTTPResponse = Data
public typealias HTTPParameters = [String: String]
public typealias HTTPHeaders = [String: String]

public enum HTTPMethod: String {
    case get = "GET"
    var name: String {
        return rawValue
    }
}

public enum HTTPError: Error, Equatable {
    case client(statusCode: Int, data: Data?) // 400 ... 499,
    case server(Int) // 500 ... 599,
    case noNetwork
    case request
    case unknown
    
    public var title: String {
        switch self {
        case .noNetwork: return "HTTPERROR.NO_NETWORK.TITLE".localized
        default: return "HTTPERROR.GENERAL.TITLE".localized
        }
    }
    
    public var messsage: String {
        switch self {
        case .client: return "HTTPERROR.GENERAL.MESSAGE".localized
        case .server: return "HTTPERROR.GENERAL.MESSAGE".localized
        case .noNetwork: return "HTTPERROR.NO_NETWORK.MESSAGE".localized
        case .request: return "HTTPERROR.GENERAL.MESSAGE".localized
        case .unknown: return "HTTPERROR.GENERAL.MESSAGE".localized
        }
    }
}

public protocol URLSessionProtocol {
    func data(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Swift.Void)
}

public protocol HTTPClientType {
    func request(_ httpRequest: HTTPRequest, response: @escaping (Result<HTTPResponse, HTTPError>) -> Void)
}

public class HTTPClient: HTTPClientType {
    
    // MARK: - Properties
    static let shared = HTTPClient.init()
    
    var session: URLSessionProtocol = URLSession.shared
    
    public func request(_ httpRequest: HTTPRequest, response: @escaping (Result<HTTPResponse, HTTPError>) -> Void) {
        guard let urlRequest = self.urlRequest(httpRequest: httpRequest) else {
            response(.failure(.request))
            return
        }
        session.data(with: urlRequest) { data, urlResponse, error in
            DispatchQueue.main.async {
                response(self.processResult(data: data, urlResponse: urlResponse, error: error))
            }
        }
    }
    
    private func processResult(data: Data?, urlResponse: URLResponse?, error: Error?) -> (Result<HTTPResponse, HTTPError>) {
        
        if error != nil {
            if let error = error as? URLError, error.code == .notConnectedToInternet {
                return .failure(HTTPError.noNetwork)
            }
            
            return .failure(HTTPError.request)
            
        } else if let httpResponse = urlResponse as? HTTPURLResponse {
            switch httpResponse.statusCode {
            case 200 ... 399:
                return parseSuccess(data: data)
                
            case 400 ... 499:
                return parseClientError(httpResponse: httpResponse, data: data)
                
            case 500 ... 599:
                return parseServerError(httpResponse: httpResponse, data: data)
                
            default:
                return .failure(HTTPError.unknown)
            }
        } else {
            return .failure(HTTPError.unknown)
        }
    }
    
    private func parseSuccess(data: Data?) -> (Result<HTTPResponse, HTTPError>) {
        guard let data = data else {
            return .failure(HTTPError.unknown)
        }
        return .success(data)
    }
    
    private func parseClientError(httpResponse: HTTPURLResponse, data: Data?) -> (Result<HTTPResponse, HTTPError>) {
        return .failure(HTTPError.client(statusCode: httpResponse.statusCode, data: data))
    }
    
    private func parseServerError(httpResponse: HTTPURLResponse, data _: Data?) -> (Result<HTTPResponse, HTTPError>) {
        return .failure(HTTPError.server(httpResponse.statusCode))
    }
    
    private func urlRequest(httpRequest: HTTPRequest) -> URLRequest? {
        guard let url = URL(string: httpRequest.urlPath) else {
            return nil
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = httpRequest.httpMethod.rawValue
        urlRequest.allHTTPHeaderFields = httpRequest.httpHeaders
        if let _body = httpRequest.body, let data = try? JSONSerialization.data(withJSONObject: _body) {
            urlRequest.httpBody = data
        }
        return urlRequest
    }
}

