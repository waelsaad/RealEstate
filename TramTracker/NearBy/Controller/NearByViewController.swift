//
//  NearByViewController.swift
//  TramTracker
//
//  Created by r00tdvd on 16/7/19 Copyright © 2019. All rights reserved.
//

import UIKit

class NearByViewController: UITableViewController {
    
    // MARK: - IBOutlets
    @IBOutlet var tramTimesTable: UITableView!
    @IBOutlet weak var clearButton: UIBarButtonItem!
    @IBOutlet weak var loadButton: UIBarButtonItem!
    
    var timer: Timer!
    
    // It would have been better to setup Dependency Injection, maybe next code challenge :)
    private var viewModel: NearByViewModel = NearByViewModel(tokenClient: TokenClient(),
                                                             tramClient: TramClient())
    
    // MARK: - Methods - Overridden
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        configureNavigationBar()
        loadTramData()
    }
    
    // MARK: - IBActions
    @IBAction func clearButtonTapped(_ sender: UIBarButtonItem) {
        clearTramData()
    }
    
    @IBAction func loadButtonTapped(_ sender: UIBarButtonItem) {
        loadTramData()
    }
}

// MARK: - Tram Data

extension NearByViewController {
    
    // MARK: - Selectors
    @objc func updateRemainingTime(){
        guard let visibleIndexPaths = tramTimesTable.indexPathsForVisibleRows else {return}
        tramTimesTable.beginUpdates()
        tramTimesTable.reloadRows(at:visibleIndexPaths, with: .none)
        tramTimesTable.endUpdates()
    }
    
    @objc func refresh(sender:AnyObject) {
        loadTramData()
    }
    
    // MARK: - Methods
    func configureViews() {
        tableView.register(forClass: NearByTableViewCell.self)
        tableView.register(forClass: TramsNotFoundTableViewCell.self)
        refreshControl = UIRefreshControl()
        refreshControl!.addTarget(self,
                                  action:#selector(refresh(sender:)) ,
                                  for: UIControl.Event.valueChanged)
        timer = Timer.scheduledTimer(timeInterval: Constants.refreshDuration,
                                     target: self,
                                     selector: #selector(updateRemainingTime), userInfo: nil, repeats: true)
    }
    
    private func configureNavigationBar() {
        guard let navigationBar = navigationController?.navigationBar else { return }
        Theme.applyAppearance(for: navigationBar, theme: .nearBy)
        navigationBar.topItem?.title = viewModel.navigationBarTitle
    }
    
    func clearTramData() {
        viewModel.resetData()
        tramTimesTable.reloadData()
    }
    
    func loadTramData() {
        clearTramData()
        let token = AppPreferences.shared.userToken
        if token.isEmpty {
            viewModel.fetchToken() {  result in
                switch result {
                case let .success(data):
                    AppPreferences.shared.saveTokenLocally(token: data.token!)
                    self.loadTramStopsByOrientation(orientation: .North)
                    self.loadTramStopsByOrientation(orientation: .South)
                case .failure:
                    self.displayError(self.viewModel.titleOops,
                                      message: self.viewModel.errorFetchingToken)
                }
            }
        } else {
            self.loadTramStopsByOrientation(orientation: .North)
            self.loadTramStopsByOrientation(orientation: .South)
        }
    }
    
    func loadTramStopsByOrientation(orientation: Direction) {
        self.viewModel.loadTramStopsByOrientation(orientation: orientation) { result in
            switch result {
            case let .success(trams):
                self.refreshControl?.endRefreshing()
                
                if trams.count == 0 {
                    self.displayError(self.viewModel.titleOops,
                                      message: self.viewModel.noUpcommingTrams)
                    return
                }
                
                if orientation == .North {
                    self.viewModel.northTrams = trams
                } else {
                    self.viewModel.southTrams = trams
                }
                self.tramTimesTable.reloadSections(IndexSet(integer: orientation == .North ? TableSections.North.rawValue :
                    TableSections.South.rawValue), with: .automatic)
            case .failure:
                self.refreshControl?.endRefreshing()
                self.displayError(self.viewModel.titleOops,
                                  message: orientation == .North ? self.viewModel.errorFetchingNorthTrams : self.viewModel.errorFetchingSouthTrams)
            }
        }
    }
    
    func tramsFor(section: Int) -> [Tram]? {
        return (section == TableSections.North.rawValue) ? viewModel.northTrams : viewModel.southTrams
    }
    
    func isLoading(section: Int) -> Bool {
        return (section == TableSections.North.rawValue) ? viewModel.loadingNorth : viewModel.loadingSouth
    }
}


// MARK - UITableViewDataSource

extension NearByViewController {
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let trams = tramsFor(section: indexPath.section)
        
        guard let tram = trams?[indexPath.row]  else {
            let cell: TramsNotFoundTableViewCell = tableView.dequeueReusableCell(forClass: TramsNotFoundTableViewCell.self)
            if !isLoading(section: indexPath.section) {
                cell.configCell(message: viewModel.noUpcommingTrams)
            }
            return cell
        }
        
        let cell: NearByTableViewCell = tableView.dequeueReusableCell(forClass: NearByTableViewCell.self)
        cell.configCell(tram: tram)
        return cell;
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return TableSections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == TableSections.North.rawValue {
            guard let count = viewModel.northTrams?.count else { return 1 }
            return count
        } else {
            guard let count = viewModel.southTrams?.count else { return 1 }
            return count
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == TableSections.North.rawValue ? viewModel.northTramsTitle : viewModel.southTramsTitle
    }
}

extension NearByViewController {
    
    struct Constants {
        static let refreshDuration = 60.0
    }
    
    enum TableSections: Int, CountableEnumeration {
        case North = 0
        case South
    }
}

