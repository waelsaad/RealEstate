//
//  NearByViewModel.swift
//  TramTracker
//
//  Created by r00tdvd on 16/7/19 Copyright © 2019. All rights reserved.
//

import Foundation

enum Direction: Int, CaseIterable {
    case North = 1
    case South
}

protocol NearByViewModelType {
    
    var navigationBarTitle: String { get }
    
    var northTramsTitle: String { get }
    var southTramsTitle: String { get }

    var titleOK: String { get }
    var titleOops: String { get }
    
    var noUpcommingTrams: String { get }
    var errorFetchingToken: String { get }
    var errorFetchingNorthTrams: String { get }
    var errorFetchingSouthTrams: String { get }
    
    // MARK: - Properties

    var northTrams: [Tram]? { get set }
    var southTrams: [Tram]? { get set }
    
    var loadingNorth: Bool { get set }
    var loadingSouth: Bool { get set }
    
    // Mark: - Functions
    func resetData()
    
    func fetchToken(completion: @escaping (Result<Token, HTTPError>) -> Void)
    func loadTramStopsByOrientation(orientation: Direction, completion: @escaping (Result<[Tram], HTTPError>) -> Void)
}

class NearByViewModel: NearByViewModelType {

    var northTrams: [Tram]? = []
    var southTrams: [Tram]? = []
    
    var loadingNorth: Bool = false
    var loadingSouth: Bool = false
    
    var navigationBarTitle: String {
        return "NEAR.BY.NAVIGATION.TITLE".localized
    }

    var titleOK: String {
        return "ALERT.OK".localized
    }
    
    var titleOops: String {
        return "ALERT.OOPS!".localized
    }
    
    var noUpcommingTrams: String {
        return "NO.UPCOMING.TRAMS".localized
    }
    
    var errorFetchingToken: String {
        return "ERROR.FETCHING.TOKEN".localized
    }
    
    var errorFetchingNorthTrams: String {
        return "ERROR.FETCHING.NORTH.TRAMS".localized
    }
    
    var errorFetchingSouthTrams: String {
        return "ERROR.FETCHING.SOUTH.TRAMS".localized
    }
    
    var northTramsTitle: String {
        return "NORTH.TRAM.STOPS".localized
    }
    
    var southTramsTitle: String {
        return "SOUTH.TRAM.STOPS".localized
    }

    init(tokenClient: TokenClient, tramClient: TramClient) {
        self.tokenClient = tokenClient
        self.tramClient = tramClient
    }
    
    
    func resetData() {
        loadingNorth = false
        loadingSouth = false
        self.northTrams = nil
        self.southTrams = nil
    }
    
    //New
    func fetchToken(completion: @escaping (Result<Token, HTTPError>) -> Void) {
        tokenClient.fetchToken (completion: { result in
            switch result {
                case let .success(data):
                completion(.success(data))
                case let .failure (error):
                completion(.failure(error))
            }
        })
    }
    
    //New
    func loadTramStopsByOrientation(orientation: Direction, completion: @escaping (Result<[Tram], HTTPError>) -> Void) {
        let stopId = orientation == .North ? Constants.northStopId.description : Constants.southStopId.description
        tramClient.fetchTrams(stopID: stopId, completion: { [weak self] result in
            guard let self = self else { return }
            
            if orientation == .North {
                self.loadingNorth = false
            } else {
                self.loadingSouth = false
            }
            
            switch result {
            case let .success(data):
                completion(.success(data))
            case let .failure (error):
                completion(.failure(error))
            }
        })
    }
    
    func tramsFor(section: Int) -> [Tram]? {
        return (section == 0) ? northTrams : southTrams
    }
    
    func isLoading(section: Int) -> Bool {
        return (section == 0) ? loadingNorth : loadingSouth
    }
    
    // Private
    private var tokenClient: TokenClient
    private var tramClient: TramClient
}


extension NearByViewModel {
    struct Constants {
        static let northStopId = 4055
        static let southStopId = 4155
    }
}
