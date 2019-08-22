//
//  NearByViewControllerSpec.swift
//  TramTracker
//
//  Created by r00tdvd on 16/7/19 Copyright © 2019. All rights reserved.
//

import Foundation
import Quick
import Nimble

@testable import TramTracker

class NearByViewControllerSpec: QuickSpec {
    
    override func spec() {
        
        describe("NearByViewController") {
            
            var viewController: NearByViewController?
            
            beforeEach {
                let storyboard = UIStoryboard(name: "NearBy", bundle: nil)
                viewController = storyboard.instantiateViewController(withIdentifier: "NearByViewController") as? NearByViewController
                _ = viewController?.view
            }
            
            // MARK: - Table secion count test
            it("should have sections for north and south") {
                let sections = viewController?.tramTimesTable.numberOfSections
                expect(sections) == 2
            }
            
            // MARK: - No data test
            it("should initialize no tram data") {
                let tramsTable = viewController?.tramTimesTable
                
                let north = tramsTable?.numberOfRows(inSection: 0)
                expect(north) == 1
                
                let placeholderCell = tramsTable?.cellForRow(at: IndexPath(row: 0, section: 0)) as! TramsNotFoundTableViewCell
                placeholderCell.configCell(message: "No upcoming trams")
                
                let placeholder = placeholderCell.messageLabel.text
                expect(placeholder?.hasPrefix("No upcoming trams")) == true
                
                let south = tramsTable?.numberOfRows(inSection: 1)
                expect(south) == 1
            }
            
            it("should display north tram data on table after api response") {
                var viewModel: NearByViewModelType!
                viewModel = NearByViewModel(tokenClient: TokenClient(), tramClient: TramClient())
                let tramsTable = viewController?.tramTimesTable
                viewController?.loadTramData()
                tramsTable?.reloadData()
   
                viewModel.loadTramStopsByOrientation(orientation: .North, completion: { result in
                    switch result {
                    case .success:
                        let northTramCell = tramsTable?.cellForRow(at: IndexPath(row: 0, section: 0)) as! NearByTableViewCell
                        expect(northTramCell.destinationLabel.text) == "North Richmond"
                    case let .failure(error):
                        expect(error).notTo(beNil())
                    }
                })
            }

            it("should display south tram data on table after api response") {
                var viewModel: NearByViewModelType!
                viewModel = NearByViewModel(tokenClient: TokenClient(), tramClient: TramClient())
                let tramsTable = viewController?.tramTimesTable
                viewController?.loadTramData()
                tramsTable?.reloadData()
                
                viewModel.loadTramStopsByOrientation(orientation: .South, completion: { result in
                    switch result {
                    case .success:
                        let southTramCell = tramsTable?.cellForRow(at: IndexPath(row: 0, section: 1)) as! NearByTableViewCell
                        expect(southTramCell.destinationLabel.text) == "Balaclava"
                    case let .failure(error):
                        expect(error).notTo(beNil())
                    }
                })
            }
            
            
            it("should clear data and tableview should have one placeholder cell"){
                UIApplication.shared.sendAction((viewController?.clearButton.action)!,
                                                to: viewController?.clearButton.target, from: self, for: nil)
                let tramsTable = viewController?.tramTimesTable
                expect(tramsTable?.numberOfRows(inSection: 0)) == 1
                expect(tramsTable?.numberOfRows(inSection: 1)) == 1
            }
        }
    }
}
