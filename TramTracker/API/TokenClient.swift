//
//  TokenClient.swift
//  TramTracker
//
//  Created by r00tdvd on 16/7/19 Copyright © 2019. All rights reserved.
//

import Foundation

class TokenClient {

    // MARK: - Properties
    private let manager = HTTPClient.shared
    
//    // MARK: - Methods
//    func fetchToken(completion: @escaping (_ responseData: String?, _ error: Error?) -> Void) {
//        let endpoint = Endpoint.fetchToken.absoluteURL()
//        manager.request(url: endpoint, success: { (token) in
//            for tokenDict in token {
//                do{
//                    let tokenObj = try Token(from: tokenDict)
//                    completion(tokenObj.token, nil)
//                    break
//                }catch {
//                    completion("", NSError(domain: "Parse Error", code: 152, userInfo: nil) as Error)
//                }
//            }
//        }) { (error) in
//            completion("", error)
//        }
//    }
    
    //New
    func fetchToken(completion: @escaping (Result<Token, HTTPError>) -> Void) {
        let path = Endpoint.fetchToken.absoluteURL()
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
                    let response = try decoder.decode(TokenServerResponse.self, from: data)
                    let data = response.responseObject
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
