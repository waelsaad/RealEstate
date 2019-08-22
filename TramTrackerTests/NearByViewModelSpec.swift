//
//  HTTPClient.swift
//  TramTracker
//
//  Created by r00tdvd on 16/7/19 Copyright © 2019. All rights reserved.
//

import Quick
import Nimble

@testable import TramTracker

final class NearByViewModelSpec: QuickSpec {
    
    override func spec() {
        
        describe("a view model for the NearBy screen") {
            
            var viewModel: NearByViewModelType!
            var tokenClient: MockSuccessTokenClient!
            var tramClient: MockSuccessTramClient!
            
            beforeEach {
                tokenClient = MockSuccessTokenClient()
                tramClient = MockSuccessTramClient()
                viewModel = NearByViewModel(tokenClient: tokenClient, tramClient: tramClient)
            }
            
            afterEach {
                viewModel = nil
            }
            
            it("has title for navigation bar") {
                expect(viewModel.navigationBarTitle).to(equal("NearBy"))
            }
            
            it("table section north tram title") {
                expect(viewModel.northTramsTitle).to(equal("North Tram Stops"))
            }
            
            it("table section south tram title") {
                expect(viewModel.southTramsTitle).to(equal("South Tram Stops"))
            }
            
            it("alert Ok Button title") {
                expect(viewModel.titleOK).to(equal("OK"))
            }
            
            it("alert title") {
                expect(viewModel.titleOops).to(equal("Oops!"))
            }
            
            it("when there are no trams label") {
                expect(viewModel.noUpcommingTrams).to(equal("No upcoming trams. Pull to fetch"))
            }
            
            it("when there is an error fetching a user token") {
                expect(viewModel.errorFetchingToken).to(equal("Error occured while fetching the token, please try to reload!"))
            }
            
            it("when there is an error fetching north trams") {
                expect(viewModel.errorFetchingNorthTrams).to(equal("Error occured while loading the north trams, please try to reload!"))
            }
            
            it("when there is an error fetching south trams") {
                expect(viewModel.errorFetchingSouthTrams).to(equal("Error occured while loading the south trams, please try to reload!"))
            }
    
            //New
            context("When to fetch token is success") {
                it("returns http success") {

                    var token: String!
                    let tokenClient = TokenClient()
                    
                    waitUntil(timeout: 3) { done in
                        tokenClient.fetchToken(completion: { result in
                            switch result {
                            case let .success(data):
                                token = data.token
                                expect(token).notTo(beNil())
                            case let .failure(error):
                                expect(error).notTo(beNil())
                            }
                            done()
                        })
                    }
                }
            }
            
            //New
            context("When there are tram records") {
                it("returns http success") {
                    
                    var requestError: Error!
                    let tramClient = TramClient()
                    
                    tramClient.fetchTrams(stopID: "4055", completion: { result in
                        switch result {
                        case let .success(trams):
                            expect(requestError).to(beNil())
                            expect(trams.count).to(beGreaterThanOrEqualTo(0))
                        case let .failure(error):
                            requestError = error
                            expect(error).notTo(beNil())
                        }
                    })
                }
            }
            
            context("When there are no tram records") {
                it("returns http success") {
                    let tramClient = TramClient()
                    tramClient.fetchTrams(stopID: "0", completion: { result in
                        switch result {
                        case let .success(trams):
                            expect(trams.count).to(equal(0))
                        case let .failure(error):
                            expect(error).notTo(beNil())
                        }
                    })
                
                }
            }
        }
    }
}

private final class MockSuccessTokenClient: TokenClient {
    var userToken: String = "47501835-514d-4436-ac09-1d9ef861b195"
}

private final class MockSuccessTramClient: TramClient {
    func fetchTrams() -> [Tram] {
        return [Tram(routeNumber: "78", destination: "North Richmond", predictedArrivalTime: "/Date(1563327564000+1000)/")]
    }
}

