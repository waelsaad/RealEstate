//
//  TramClient.swift
//  TramTracker
//
//  Created by r00tdvd on 16/7/19 Copyright © 2019. All rights reserved.
//

import Foundation

class TramClient {
    
    // MARK: - Properties
    private let manager = HTTPClient.shared
    
    // MARK: - Methods
    
    //    func fetchTrams(stopID: String, completion: @escaping (_ responseData: [Tram]?, _ error: Error?) -> Void) {
    //        let token = AppPreferences.shared.userToken
    //        let endpoint = Endpoint.fetchTrams(token: token, stopId: stopID).absoluteURL()
    //        manager.request(url: endpoint, success: { (response:[Any]) in
    //            do {
    //                var trams = [Tram]()
    //                for tramDict in response {
    //                    let tramObj = try Tram(from: tramDict)
    //                    trams.append(tramObj)
    //                }
    //                completion(trams, nil)
    //            } catch {
    //                completion(nil, NSError(domain: "Parsing Error", code: 152, userInfo: nil) as Error)
    //            }
    //
    //        }) { (error) in
    //            completion(nil,error)
    //        }
    //    }
    
    // New
    func fetchTrams(stopID: String, completion: @escaping (Result<[Tram], HTTPError>) -> Void) {

        let token = AppPreferences.shared.userToken
        
        let path = Endpoint.fetchTrams(token: token, stopId: stopID).absoluteURL()
        
        let httpRequestBuilder = HTTPRequestBuilder()
            .addPath(path)
            .addMethod(.get)

        let httpRequest = httpRequestBuilder.build()
        
        manager.request(httpRequest) { httpResponse in
            switch httpResponse {
            case let .success(data):
                let decoder = JSONDecoder()
                do {
                    //print(String(bytes: data, encoding: .utf8)!)
                    let response = try decoder.decode(TramServerResponse.self, from: data)
                    let data = response.responseObject  ?? []
                    completion(.success(data))
                } catch let error {
                    print(error)
                    // This is a parse error
                    completion(.failure(HTTPError.unknown))
                }
            case let .failure(error):
                print(error)
                let code = (error as NSError).code
                // This is a server error
                completion(.failure(HTTPError.server(code)))
            }
        }
    }
}
